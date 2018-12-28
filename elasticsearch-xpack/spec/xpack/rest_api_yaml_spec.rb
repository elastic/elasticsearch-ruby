require 'spec_helper'

RSpec::Matchers.define :match_response_field_length do |expected_pairs|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      # joe.metadata.key2 => ['joe', 'metadata', 'key2']
      split_key = expected_key.split('.')

      actual_value = split_key.inject(response) do |response, key|
        # If the key is an index, indicating element of a list
        if key =~ /\A[-+]?[0-9]+\z/
          response[key.to_i]
        else
          response[key]
        end
      end
      actual_value.size == expected_value
    end
  end
end

RSpec::Matchers.define :match_response do |test, expected_pairs|

  match do |response|

    expected_pairs.all? do |expected_key, expected_value|

      # See test xpack/10_basic.yml
      # The master node id must be injected in the keys of match clauses
      if expected_key =~ /nodes\.\$master\.modules/
        expected_key = inject_master_node_id(expected_key, test)
      end
        # joe.metadata.key2 => ['joe', 'metadata', 'key2']
        split_key = expected_key.split('.')

        actual_value = split_key.inject(response) do |response, key|
          # If the key is an index, indicating element of a list
          if key =~ /\A[-+]?[0-9]+\z/
            response[key.to_i]
          else
            response[key]
          end
        end

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
    split_key = expected_key.split('.')
    split_key.each_with_index do |value, i|
      # Replace the $master key in the nested document with the cached master node's id
      # See test xpack/10_basic.yml
      if value == "$master"
        split_key[i] = test.cached_values['$master_node']
      end
    end
    split_key.join('.')
  end
end


RSpec::Matchers.define :match_error do |expected_error|

  match do |actual_error|
    # Remove surrounding '/' in string representing Regex
    expected_error = expected_error.tr("/", "")
    message = actual_error.message.tr("\\","")

    case expected_error
      when 'missing'
        message =~ /\[404\]/
      when 'conflict'
        message =~ /\[409\]/
      when 'request'
        message =~ /\[500\]/
      when 'bad_request'
        message =~ /\[400\]/
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

    test_file = Elasticsearch::RestAPIYAMLTests::TestFile.new(file, SKIP_FEATURES)

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

          before(:all) do
            # Runs once before each test in a test file
            begin
              DEFAULT_CLIENT.xpack.watcher.get_watch(id: "test_watch")
              DEFAULT_CLIENT.xpack.watcher.delete_watch(id: "test_watch")
            rescue
            end
            DEFAULT_CLIENT.indices.delete(index: 'test*')
            test_file.setup(DEFAULT_CLIENT)
          end

          after(:all) do
            test_file.teardown(DEFAULT_CLIENT)
          end

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
                    expect(task_group.exception.message).to match(/#{match['match'].values.first}/)
                  end
                end
              end

            # 'match' is in the task group definition
            elsif task_group.has_match_clauses?

              it 'sends the request and receives the expected response' do
                task_group.run(client)
                task_group.match_clauses.each do |match|
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
