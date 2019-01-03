require 'spec_helper'

RSpec::Matchers.define :match_response_field_length do |expected_pairs|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      # joe.metadata.2.key2 => ['joe', 'metadata', 2, 'key2']
      split_key = expected_key.split('.').map do |key|
        (key =~ /\A[-+]?[0-9]+\z/) ? key.to_i: key
      end

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key]
        end
      end
      actual_value.size == expected_value
    end
  end
end

RSpec::Matchers.define :match_response do |test, expected_pairs|

  match do |response|

    # sql test returns results at '$body' key. See sql/translate.yml
    expected_pairs = expected_pairs['$body'] if expected_pairs['$body']

    # sql test has a String response. See sql/sql.yml
    if expected_pairs.is_a?(String)
      return compare_string_response(response, expected_pairs)
    end

    expected_pairs.all? do |expected_key, expected_value|

      # See test xpack/10_basic.yml
      # The master node id must be injected in the keys of match clauses
      expected_key = inject_master_node_id(expected_key, test)

      # joe.metadata.2.key2 => ['joe', 'metadata', 2, 'key2']
      split_key = expected_key.split('.').map do |key|
        (key =~ /\A[-+]?[0-9]+\z/) ? key.to_i: key
      end

      actual_value = split_key.inject(response) { |_response, key| _response[key] }

      # When you must match a regex. For example:
      #   match: {task: '/.+:\d+/'}
      if expected_value.is_a?(String) && expected_value[0] == "/" && expected_value[-1] == "/"
        /#{expected_value.tr("/", "")}/ =~ actual_value
      else
        actual_value == expected_value
      end
    end
  end

  def inject_master_node_id(expected_key, test)
    # Replace the $master key in the nested document with the cached master node's id
    # See test xpack/10_basic.yml
    if test.cached_values['$master']
      expected_key.gsub(/\$master/, test.cached_values['$master'])
    else
      expected_key
    end
  end

  def compare_string_response(response, expected_string)
    regexp = Regexp.new(expected_string.strip[1..-2], Regexp::EXTENDED|Regexp::MULTILINE)
    regexp =~ response
  end
end


RSpec::Matchers.define :match_error do |expected_error|

  match do |actual_error|
    # Remove surrounding '/' in string representing Regex
    expected_error = expected_error.tr("/", "")
    message = actual_error.message.tr("\\","")

    case expected_error
      when 'request_timeout'
        message =~ /\[408\]/
      when 'missing'
        message =~ /\[404\]/
      when 'conflict'
        message =~ /\[409\]/
      when 'request'
        message =~ /\[500\]/
      when 'bad_request'
        message =~ /\[400\]/
    when 'param'
        message =~ /\[400\]/ ||
        actual_error.is_a?(ArgumentError)
      when 'unauthorized'
        actual_error.is_a?(Elasticsearch::Transport::Transport::Errors::Unauthorized)
      when 'forbidden'
        actual_error.is_a?(Elasticsearch::Transport::Transport::Errors::Forbidden)
      else
        message =~ /#{expected_error}/
    end
  end
end

describe 'XPack Rest API YAML tests' do

  REST_API_YAML_FILES.each do |file|

    test_file = Elasticsearch::RestAPIYAMLTests::TestFile.new(file, REST_API_YAML_SKIP_FEATURES)

    context "#{test_file.name}" do

      before(:all) do
        # Runs once before all tests in a test file
        Elasticsearch::RestAPIYAMLTests::TestFile.prepare(DEFAULT_CLIENT)
      end

      test_file.tests.each do |test|

        context "#{test.description}" do

          let(:client) do
            DEFAULT_CLIENT
          end

          # Runs once before each test in a test file
          before(:all) do
            begin
              # todo: remove these two lines when Dimitris' PR is merged
              DEFAULT_CLIENT.cluster.put_settings(body: { transient: { "xpack.ml.max_model_memory_limit" => nil } })
              DEFAULT_CLIENT.cluster.put_settings(body: { persistent: { "xpack.ml.max_model_memory_limit" => nil } })

              DEFAULT_CLIENT.xpack.watcher.get_watch(id: "test_watch")
              DEFAULT_CLIENT.xpack.watcher.delete_watch(id: "test_watch")
            rescue
            end
            Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_indices, DEFAULT_CLIENT)
            Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_datafeeds, DEFAULT_CLIENT)
            Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_ml_jobs, DEFAULT_CLIENT)
            Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_rollup_jobs, DEFAULT_CLIENT)
            Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_machine_learning_indices, DEFAULT_CLIENT)
            test_file.setup(DEFAULT_CLIENT)
            puts "STARTING TEST"
          end

          after(:all) do
            test_file.teardown(DEFAULT_CLIENT)
          end

          if test.skip_test?
            skip 'Test contains features not yet support'

          else

            test.task_groups.each do |task_group|

              # 'catch' is in the task group definition
              if task_group.catch_exception?

                it 'sends the request and throws the expected error' do
                  task_group.run(client)
                  expect(task_group.exception).to match_error(task_group.expected_exception_message)
                end

                # 'match' on error description is in the task group definition
                if task_group.has_match_clauses?

                  it 'contains the expected error in the request response' do
                    task_group.run(client)
                    task_group.match_clauses.each do |match|
                      expect(task_group.exception.message).to match(Regexp.new(Regexp.escape(match['match'].values.first.to_s)))
                    end
                  end
                end

              # 'match' is in the task group definition
              elsif task_group.has_match_clauses?

                it 'sends the request and receives the expected response' do
                  task_group.run(client)
                  task_group.match_clauses.each do |match|
                    skip 'Must implement parsing of backslash and dot' if match['match'].keys.any? { |keys| keys =~ /\\/ }
                    expect(task_group.response).to match_response(test, match['match'])
                  end
                end

              # 'length' is in the task group definition
              elsif task_group.has_length_match_clauses?

                it 'sends the request and the response fields have the expected length' do
                  task_group.run(client)
                  task_group.length_match_clauses.each do |match|
                    expect(task_group.response).to match_response_field_length(match['length'])
                  end
                end

              else

                # no verification is in the task group definition
                it 'executes the request' do
                  task_group.run(client)
                end
              end
            end
          end
        end
      end
    end
  end
end
