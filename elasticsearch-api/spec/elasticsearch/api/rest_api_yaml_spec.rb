# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'
require 'rest_api_tests_helper'
require_relative './run_rspec_matchers'

LOGGER = Logger.new($stdout)

describe 'Rest API YAML tests' do
  if REST_API_YAML_FILES.empty?
    LOGGER.error 'No test files found!'
    LOGGER.info 'Use rake rake elasticsearch:download_artifacts in the root directory of the project to download the test artifacts.'
    exit 1
  end

  # Traverse YAML files and create TestFile object:
  REST_API_YAML_FILES.each do |file|
    begin
      test_file = Elasticsearch::RestAPIYAMLTests::TestFile.new(file, ADMIN_CLIENT, REST_API_YAML_SKIP_FEATURES)
      context_name = file.gsub("#{YAML_FILES_DIRECTORY}/", '')
    rescue SkipTestsException => e
      # If the test file has a `skip` at the top level that applies to this
      # version of Elasticsearch, continue with the next text.
      LOGGER.info e.message
      next
    end

    context context_name do
      let(:client) { DEFAULT_CLIENT }

      test_file.tests.each do |test|
        context test.description do
          if test.skip_test?(ADMIN_CLIENT)
            skip 'Test contains feature(s) not yet supported or version is not satisfied'
            next
          end

          before(:all) { test_file.setup }

          after(:all) do
            test_file.teardown
            Elasticsearch::RestAPIYAMLTests::WipeCluster.run(ADMIN_CLIENT)
          end

          test.task_groups.each do |task_group|
            before do
              task_group.run(client)
            end

            # ./run_task_groups.rb
            run_rspec_matchers_on_task_group(task_group, test)
          end
        end
      end
    end
  end
end
