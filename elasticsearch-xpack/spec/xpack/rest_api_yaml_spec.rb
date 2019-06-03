# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'
require 'rest_yaml_tests_helper'

RSpec::Matchers.define :match_response_field_length do |expected_pairs|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      # ssl test returns results at '$body' key. See ssl/10_basic.yml
      expected_pairs = expected_pairs['$body'] if expected_pairs['$body']

      split_key = Test.split_and_parse_key(expected_key)

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

RSpec::Matchers.define :match_true_field do |field|

  match do |response|
    # Handle is_true: ''
    return response == true if field == ''
    !!Test.find_value_in_document(split_and_parse_key(field), response)
  end
end

RSpec::Matchers.define :match_false_field do |field|

  match do |response|
    # Handle is_false: ''
    return response == false if field == ''
    !Test.find_value_in_document(split_and_parse_key(field), response)
  end
end

RSpec::Matchers.define :match_gte_field do |expected_pairs|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      split_key = Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key]
        end
      end
      actual_value >= expected_value
    end
  end
end

RSpec::Matchers.define :match_gt_field do |expected_pairs, test|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      split_key = Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key]
        end
      end
      actual_value > test.get_cached_value(expected_value)
    end
  end
end

RSpec::Matchers.define :match_lte_field do |expected_pairs|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      split_key = Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key]
        end
      end
      actual_value <= expected_value
    end
  end
end

RSpec::Matchers.define :match_lt_field do |expected_pairs|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      split_key = Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key]
        end
      end
      actual_value < expected_value
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
      expected_key = test.inject_master_node_id(expected_key)

      split_key = Test.split_and_parse_key(expected_key)
      actual_value = Test.find_value_in_document(split_key, response)

      # Sometimes the expected value is a cached value from a previous request.
      # See test api_key/10_basic.yml
      expected_value = test.get_cached_value(expected_value)

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
    if test.cached_values['master']
      expected_key.gsub(/\$master/, test.cached_values['master'])
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

    context "#{file.gsub("#{YAML_FILES_DIRECTORY}/", '')}" do

      before(:all) do
        # Runs once before all tests in a test file
        Elasticsearch::RestAPIYAMLTests::TestFile.clear_data_xpack(ADMIN_CLIENT)
      end

      test_file.tests.each do |test|

        context "#{test.description}" do

          if test.skip_test?(ADMIN_CLIENT)
            skip 'Test contains feature(s) not yet support or version is not satisfied'

          else

            let(:client) do
              DEFAULT_CLIENT
            end

            # Runs once before each test in a test file
            before(:all) do
              begin
                # watcher/get_watch/30_with_chain_input.yml needs to have a teardown deleting my_watch.
                ADMIN_CLIENT.xpack.watcher.delete_watch(id: "my_watch")
              rescue Elasticsearch::Transport::Transport::Errors::NotFound
              end

              # todo: remove these two lines when Dimitris' PR is merged
              ADMIN_CLIENT.cluster.put_settings(body: { transient: { "xpack.ml.max_model_memory_limit" => nil } })
              ADMIN_CLIENT.cluster.put_settings(body: { persistent: { "xpack.ml.max_model_memory_limit" => nil } })
              Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_datafeeds, ADMIN_CLIENT)
              Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_ml_jobs, ADMIN_CLIENT)
              Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_tasks, ADMIN_CLIENT)
              Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_rollup_jobs, ADMIN_CLIENT)
              Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_machine_learning_indices, ADMIN_CLIENT)
              Elasticsearch::RestAPIYAMLTests::TestFile.send(:clear_indices, ADMIN_CLIENT)
              test_file.setup(ADMIN_CLIENT)
            end

            after(:all) do
              test_file.teardown(ADMIN_CLIENT)
            end

            test.task_groups.each do |task_group|

              before do
                task_group.run(client)
              end

              # 'catch' is in the task group definition
              if task_group.catch_exception?

                it 'sends the request and throws the expected error' do
                  expect(task_group.exception).to match_error(task_group.expected_exception_message)
                end

                # 'match' on error description is in the task group definition
                if task_group.has_match_clauses?

                  task_group.match_clauses.each do |match|
                    it 'contains the expected error in the request response' do
                      expect(task_group.exception.message).to match(Regexp.new(Regexp.escape(match['match'].values.first.to_s)))
                    end
                  end
                end
              else

                # 'match' is in the task group definition
                if task_group.has_match_clauses?

                  task_group.match_clauses.each do |match|
                    it "has the expected value (#{match['match'].values.join(',')}) in the response field (#{match['match'].keys.join(',')})" do
                      expect(task_group.response).to match_response(test, match['match'])
                    end
                  end
                end

                # 'length' is in the task group definition
                if task_group.has_length_match_clauses?

                  task_group.length_match_clauses.each do |match|
                    it "the '#{match['length'].keys.join(',')}' field have the expected length" do
                      expect(task_group.response).to match_response_field_length(match['length'])
                    end
                  end
                end

                # 'is_true' is in the task group definition
                if task_group.has_true_clauses?

                  task_group.true_clauses.each do |match|
                    it 'sends the request and the response fields have the expected fields set to true' do
                      expect(task_group.response).to match_true_field(match['is_true'])
                    end
                  end
                end

                # 'is_false' is in the task group definition
                if task_group.has_false_clauses?

                  task_group.false_clauses.each do |match|
                    it 'sends the request and the response fields have the expected fields set to false' do
                      expect(task_group.response).to match_false_field(match['is_false'])
                    end
                  end
                end

                # 'gte' is in the task group definition
                if task_group.has_gte_clauses?

                  task_group.gte_clauses.each do |match|
                    it 'sends the request and the response fields have values greater than or equal to the expected values' do
                      expect(task_group.response).to match_gte_field(match['gte'])
                    end
                  end
                end

                # 'gt' is in the task group definition
                if task_group.has_gt_clauses?

                  task_group.gt_clauses.each do |match|
                    it 'sends the request and the response fields have values greater than to the expected values' do
                      expect(task_group.response).to match_gt_field(match['gt'], test)
                    end
                  end
                end

                # 'lte' is in the task group definition
                if task_group.has_lte_clauses?

                  task_group.lte_clauses.each do |match|
                    it 'sends the request and the response fields have values less than or equal to the expected values' do
                      expect(task_group.response).to match_lte_field(match['lte'])
                    end
                  end
                end

                # 'lt' is in the task group definition
                if task_group.has_lt_clauses?

                  task_group.lt_clauses.each do |match|
                    it 'sends the request and the response fields have values less than to the expected values' do
                      expect(task_group.response).to match_lt_field(match['lt'])
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
