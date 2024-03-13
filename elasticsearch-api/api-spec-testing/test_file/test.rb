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

module Elasticsearch
  module RestAPIYAMLTests
    class TestFile
      # Represents a single test in a test file. A single test can have many operations and validations.
      #
      # @since 6.2.0
      class Test
        class << self
          # Given a list of keys, find the value in a recursively nested document.
          #
          # @param [ Array<String> ] chain The list of nested document keys.
          # @param [ Hash ] document The document to find the value in.
          #
          # @return [ Object ] The value at the nested key.
          #
          # @since 6.2.0
          def find_value_in_document(chain, document)
            return document[chain] unless chain.is_a?(Array)
            return document[chain[0]] unless chain.size > 1

            # a number can be a string key in a Hash or indicate an element in a list
            if document.is_a?(Hash)
              find_value_in_document(chain[1..-1], document[chain[0].to_s]) if document[chain[0].to_s]
            elsif document[chain[0]]
              find_value_in_document(chain[1..-1], document[chain[0]]) if document[chain[0]]
            end
          end

          # Given a string representing a nested document key using dot notation,
          #   split it, keeping escaped dots as part of a key name and replacing
          #   numerics with a Ruby Integer.
          #
          # For example:
          #   "joe.metadata.2.key2" => ['joe', 'metadata', 2, 'key2']
          #   "jobs.0.node.attributes.ml\\.enabled" => ["jobs", 0, "node", "attributes", "ml\\.enabled"]
          #
          # @param [ String ] chain The list of nested document keys.
          # @param [ Hash ] document The document to find the value in.
          #
          # @return [ Array<Object> ] A list of the nested keys.
          #
          # @since 6.2.0
          def split_and_parse_key(key)
            key.split(/(?<!\\)\./).reject(&:empty?).map do |key_part|
              case key_part
              when /^\.\$/ # For keys in the form of .$key
                key_part.gsub(/^\./, '')
              when /\A[-+]?[0-9]+\z/
                key_part.to_i
              else
                key_part.gsub('\\', '')
              end
            end.reject { |k| k == '$body' }
          end
        end

        attr_reader :description, :test_file, :cached_values, :file_basename, :skip

        # Actions that if followed by a 'do' action, indicate that they complete their task group.
        # For example, consider this sequence of actions:
        #   do, do, match, match, do, match
        # The second match indicates that the task group is complete and can be run as a unit.
        # That sequence becomes two task groups:
        #   do, do, match, match
        #   do, match
        #
        # @since 6.2.0
        GROUP_TERMINATORS = [
          'length',
          'gt',
          'gte',
          'lt',
          'lte',
          'set',
          'transform_and_set',
          'match',
          'is_false',
          'is_true'
        ].freeze

        # The maximum Elasticsearch version this client version can successfully run tests against.
        #
        # @since 6.2.0
        MAX_REQUIRED_VERSION = nil

        # The minimum Elasticsearch version this client version can successfully run tests against.
        #
        # @since 6.2.0
        MIN_REQUIRED_VERSION = nil

        # Initialize the Test object.
        #
        # @example Create a test object
        #   Test.new(file, definition)
        #
        # @param [ String ] test_file The name of the test file.
        # @param [ Hash ] test_definition A hash corresponding to the parsed YAML containing the test definition.
        #
        # @since 6.2.0
        def initialize(test_file, test_definition)
          @test_file = test_file
          @file_basename = test_file.name.gsub("#{YAML_FILES_DIRECTORY}/", '')
          @description = test_definition.keys.first
          @definition = test_definition[description].select { |doc| !doc.key?('skip') }
          @definition.delete_if { |doc| doc['skip'] }
          @cached_values = {}
          skip_definitions = test_definition[description].select { |doc| doc['skip'] }.compact
          @skip = skip_definitions unless skip_definitions.empty?
        end

        # Get the list of task groups in this test.
        #
        # @example
        #   test.task_groups
        #
        # @return [ Array<TaskGroup> ] The list of task groups.
        #
        # @since 6.2.0
        def task_groups
          @task_groups ||= begin
            @definition.each_with_index.inject([]) do |task_groups, (action, i)|
              # the action has a catch, it's a singular task group
              if action['do'] && action['do']['catch']
                task_groups << TaskGroup.new(self)
              elsif action['do'] && i > 0 && is_a_validation?(@definition[i-1])
                task_groups << TaskGroup.new(self)
              elsif i == 0
                task_groups << TaskGroup.new(self)
              end

              task_groups[-1].add_action(action) && task_groups
            end
          end
        end

        # Cache a value on this test object.
        #
        # @example
        #   test.cache_value(cache_key, value)
        #
        # @param [ String ] cache_key The cache key for the value.
        # @param [ Object ] value The value to cache.
        #
        # @return [ Hash ] The cached values.
        #
        # @since 6.2.0
        def cache_value(cache_key, value)
          @cached_values[cache_key] = value
          @cached_values
        end

        # Get a cached value.
        #
        # @example
        #   test.get_cached_value('$watch_count_active')
        #
        # @param [ String ] key The key of the cached value.
        #
        # @return [ Hash ] The cached value at the key or the key if it's not found.
        #
        # @since 6.2.0
        def get_cached_value(key)
          case key
          when String
            key =~ /^\$/ ? @cached_values.fetch(key.gsub(/[\$\{\}]/, ''), key) : key
          when Hash
            key.inject({}) do |hash, (k, v)|
              k = k.to_s if [Float, Integer].include? k.class
              if v.is_a?(String)
                hash.merge(@cached_values.fetch(k.gsub(/[\$\{\}]/, ''), k) => @cached_values.fetch(v.gsub(/[\$\{\}]/, ''), v))
              else
                hash.merge(@cached_values.fetch(k.gsub(/[\$\{\}]/, ''), k) => v)
              end
            end
          when Array
            key.collect do |k|
              k.is_a?(String) ? @cached_values.fetch(k.gsub(/[\$\{\}]/, ''), k) : k
            end
          else
            key
          end
        end

        # Run all the tasks in this test.
        #
        # @example
        #   test.run(client)
        #
        # @param [ Elasticsearch::Client ] client The client to use when executing operations.
        #
        # @return [ self ]
        #
        # @since 6.2.0
        def run(client)
          task_groups.each { |task_group| task_group.run(client) }
          self
        end

        # Determine whether this test should be skipped, given a list of unsupported features.
        #
        # @example
        #   test.skip_test?(['warnings'])
        #
        # @param [ Array<String> ] features_to_skip A list of the features to skip.
        #
        # @return [ true, false ] Whether this test should be skipped, given a list of unsupported features.
        #
        # @since 6.2.0
        def skip_test?(client, features_to_skip = test_file.features_to_skip)
          return true if pre_defined_skip?

          if @skip
            @skip.collect { |s| s['skip'] }.any? do |skip_definition|
              contains_features_to_skip?(features_to_skip, skip_definition) || test_file.skip_version?(client, skip_definition)
            end
          end
        end

        # Replace the `$master` substring in a key with the cached master node's id.
        #
        # @param [ String ] expected_key The expected key, containing the substring `$master` that needs to be replaced.
        #
        # See test xpack/10_basic.yml

        # @return [ String ] The altered key.
        #
        # @since 7.2.0
        def inject_master_node_id(expected_key)
          if cached_values['master']
            expected_key.gsub(/\$master/, cached_values['master'])
          else
            expected_key
          end
        end

        private

        def contains_features_to_skip?(features_to_skip, skip_definition)
          !(features_to_skip &  ([skip_definition['features']].flatten || [])).empty?
        end

        def pre_defined_skip?
          SKIPPED_TESTS.compact.find do |t|
            file_basename == t[:file] && (description == t[:description] || t[:description] == '*')
          end
        end

        # Given the server version and the skip definition version, returns if a
        # test should be skipped. It will return true if the server version is
        # contained in the range of the test's skip definition version.
        #
        def skip_version?(client, skip_definition)
          return true if skip_definition['version'] == 'all'

          range_partition = /\s*-\s*/
          if versions = skip_definition['version'] &&
                        skip_definition['version'].partition(range_partition)
            low, high = __parse_versions(versions)
            range = low..high
            begin
              server_version = client.info['version']['number']
            rescue
              warn('Could not determine Elasticsearch version when checking if test should be skipped.')
            end
            range.cover?(server_version)
          end
        end

        def is_a_validation?(action)
          GROUP_TERMINATORS.any? { |validation| action[validation] } || expects_exception?(action)
        end

        def expects_exception?(action)
          action['do'] && action['do']['catch']
        end
      end
    end
  end
end
