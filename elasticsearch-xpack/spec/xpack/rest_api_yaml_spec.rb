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
                      expect(task_group.response).to match_response(match['match'], test)
                    end
                  end
                end

                # 'length' is in the task group definition
                if task_group.has_length_match_clauses?

                  task_group.length_match_clauses.each do |match|
                    it "the '#{match['length'].keys.join(',')}' field have the expected length" do
                      expect(task_group.response).to match_response_field_length(match['length'], test)
                    end
                  end
                end

                # 'is_true' is in the task group definition
                if task_group.has_true_clauses?

                  task_group.true_clauses.each do |match|
                    it 'sends the request and the response fields have the expected fields set to true' do
                      expect(task_group.response).to match_true_field(match['is_true'], test)
                    end
                  end
                end

                # 'is_false' is in the task group definition
                if task_group.has_false_clauses?

                  task_group.false_clauses.each do |match|
                    it 'sends the request and the response fields have the expected fields set to false' do
                      expect(task_group.response).to match_false_field(match['is_false'], test)
                    end
                  end
                end

                # 'gte' is in the task group definition
                if task_group.has_gte_clauses?

                  task_group.gte_clauses.each do |match|
                    it 'sends the request and the response fields have values greater than or equal to the expected values' do
                      expect(task_group.response).to match_gte_field(match['gte'], test)
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
                      expect(task_group.response).to match_lte_field(match['lte'], test)
                    end
                  end
                end

                # 'lt' is in the task group definition
                if task_group.has_lt_clauses?

                  task_group.lt_clauses.each do |match|
                    it 'sends the request and the response fields have values less than to the expected values' do
                      expect(task_group.response).to match_lt_field(match['lt'], test)
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
