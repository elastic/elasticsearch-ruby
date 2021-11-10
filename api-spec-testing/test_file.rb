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
require 'logger'

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
      attr_reader :features_to_skip, :name, :client
      LOGGER = Logger.new($stdout)

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
        rescue StandardError => e
          LOGGER.error e
          LOGGER.error "Filename : #{@name}"
        end
        @test_definitions = documents.reject { |doc| doc['setup'] || doc['teardown'] }
        @setup = documents.find { |doc| doc['setup'] }
        skip_entire_test_file? if @setup
        @teardown = documents.find { |doc| doc['teardown'] }
        @features_to_skip = REST_API_YAML_SKIP_FEATURES + features_to_skip
      end

      def skip_entire_test_file?
        @skip = @setup['setup']&.select { |a| a['skip'] }
        return false if @skip.empty?

        raise SkipTestsException if skip_version?(@client, @skip.first['skip'])
      end

      def skip_version?(client, skip_definition)
        return true if skip_definition['version'] == 'all'

        range_partition = /\s*-\s*/
        return unless (versions = skip_definition['version'])

        low, high = __parse_versions(versions.partition(range_partition))
        range = low..high
        begin
          server_version = client.info['version']['number']
        rescue
          warn('Could not determine Elasticsearch version when checking if test should be skipped.')
        end
        range.cover?(Gem::Version.new(server_version))
      end

      def __parse_versions(versions)
        versions = versions.split('-') if versions.is_a? String

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
        count = 0
        loop do
          actions.delete_if do |action|
            begin
              action.execute(client)
              true
            rescue Elasticsearch::Transport::Transport::Errors::ServiceUnavailable => e
              # The action sometimes gets the cluster in a recovering state, so we
              # retry a few times and then raise an exception if it's still
              # happening
              count += 1
              raise e if count > 9

              false
            end
          end
          break if actions.empty?
        end

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
        actions.each { |action| action.execute(client) }
        self
      end

      class << self
      end
    end
  end
end
