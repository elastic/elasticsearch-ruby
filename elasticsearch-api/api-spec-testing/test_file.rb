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

require_relative 'test_file/action'
require_relative 'test_file/test'
require_relative 'test_file/task_group'
require_relative 'logging'

module Elasticsearch
  module RestAPIYAMLTests
    # Custom exception to raise when a test file needs to be skipped. This is
    # captured as soon as possible so the test runners can move on to the next test.
    class SkipTestsException < StandardError
    end

    # Class representing a single test file, containing a setup, teardown, and multiple tests.
    #
    # @since 6.2.0
    class TestFile
      include Elasticsearch::RestAPIYAMLTests::Logging
      attr_reader :features_to_skip, :name, :client

      # Initialize a single test file.
      #
      # @example Create a test file object.
      #   TestFile.new(file_name)
      #
      # @param [ String ] file_name The name of the test file.
      # @param [ Client] An instance of the client
      # @param [ Array<Symbol> ] skip_features The names of features to skip.
      #
      # @since 6.1.0
      def initialize(file_name, client, features_to_skip = [])
        @name = file_name
        @client = client
        begin
          documents = YAML.load_stream(File.new(file_name))
        rescue Psych::SyntaxError => e
          raise e unless e.message.include?('found unexpected \':\'')

          message = "Exception found when parsing YAML in #{file_name}: #{e.message}"
          logger.error message
          raise SkipTestsException, message
        rescue StandardError => e
          logger.error e
          logger.error "Filename : #{@name}"
        end
        @test_definitions = documents.reject { |doc| doc['setup'] || doc['teardown'] }
        @setup = documents.find { |doc| doc['setup'] }
        skip_entire_test_file?(file_name) if @setup
        @teardown = documents.find { |doc| doc['teardown'] }
        @features_to_skip = REST_API_YAML_SKIP_FEATURES + features_to_skip
      end

      def skip_entire_test_file?(file_name)
        @skip = @setup['setup']&.select { |a| a['skip'] }
        return false if @skip.empty?

        raise SkipTestsException, "Skipping #{file_name} due to 'skip all'." if skip_version?(@client, @skip.first['skip'])
      end

      def skip_version?(client, skip_definition)
        return true if skip_definition.fetch('version', '').include? 'all'

        return unless (versions = skip_definition['version'])

        low, high = __parse_versions(versions)
        range = low..high
        begin
          server_version = client.info['version']['number']
        rescue
          warn('Could not determine Elasticsearch version when checking if test should be skipped.')
        end
        range.cover?(Gem::Version.new(server_version))
      end

      def __parse_versions(versions)
        if versions.count('-') == 2
          versions = versions.gsub(/\s/, '').gsub(/-/, '').split(',')
        else
          range_partition = /\s*-\s*/
          versions = versions.partition(range_partition)
          versions = versions.split('-') if versions.is_a? String
        end

        low = (['', nil].include? versions[0]) ? '0' : versions[0]
        high = (['', nil].include? versions[2]) ? '9999' : versions[2]
        [Gem::Version.new(low), Gem::Version.new(high)]
      end

      # Get a list of tests in the test file.
      #
      # @example Get the list of tests
      #   test_file.tests
      #
      # @return [ Array<Test> ] A list of Test objects.
      #
      # @since 6.2.0
      def tests
        @test_definitions.collect do |test_definition|
          Test.new(self, test_definition)
        end
      end

      # Run the setup tasks defined for a single test file.
      #
      # @example Run the setup tasks.
      #   test_file.setup
      #
      # @param [ Elasticsearch::Client ] client The client to use to perform the setup tasks.
      #
      # @return [ self ]
      #
      # @since 6.2.0
      def setup
        return unless @setup

        actions = @setup['setup'].select { |action| action['do'] }.map { |action| Action.new(action['do']) }
        run_actions_and_retry(actions)
        self
      end

      # Run the teardown tasks defined for a single test file.
      #
      # @example Run the teardown tasks.
      #   test_file.teardown
      #
      # @param [ Elasticsearch::Client ] client The client to use to perform the teardown tasks.
      #
      # @return [ self ]
      #
      # @since 6.2.0
      def teardown
        return unless @teardown

        actions = @teardown['teardown'].select { |action| action['do'] }.map { |action| Action.new(action['do']) }
        run_actions_and_retry(actions)
        self
      end

      # Helper function to run actions. If the server returns an error, give it some time and retry
      # for a few times.
      def run_actions_and_retry(actions)
        count = 0
        loop do
          actions.delete_if do |action|
            begin
              action.execute(client)
              true
            rescue Elastic::Transport::Transport::Errors::RequestTimeout,
                   Net::ReadTimeout, # TODO: Replace this if we change adapters
                   Elastic::Transport::Transport::Errors::ServiceUnavailable => e
              # The action sometimes gets the cluster in a recovering state, so we
              # retry a few times and then raise an exception if it's still
              # happening
              count += 1
              sleep 10
              logger.debug(
                "The server responded with an #{e.class} error. Retrying action - (#{count})"
              )
              raise e if count > 11

              false
            end
          end
          break if actions.empty?
        end
      end
    end
  end
end
