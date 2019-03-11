module Elasticsearch

  module RestAPIYAMLTests

    class TestFile

      # Represents a single test in a test file. A single test can have many operations and validations.
      #
      # @since 6.1.1
      class Test

        attr_reader :description
        attr_reader :test_file
        attr_reader :cached_values

        # Actions that if followed by a 'do' action, indicate that they complete their task group.
        # For example, consider this sequence of actions:
        #   do, do, match, match, do, match
        # The second match indicates that the task group is complete and can be run as a unit.
        # That sequence becomes two task groups:
        #   do, do, match, match
        #   do, match
        #
        # @since 6.1.1
        GROUP_TERMINATORS = [ 'length',
                              'gt',
                              'set',
                              'match',
                              'is_false',
                              'is_true'
        ].freeze

        # The maximum Elasticsearch version this client version can successfully run tests against.
        #
        # @since 6.1.1
        MAX_REQUIRED_VERSION = nil

        # The minimum Elasticsearch version this client version can successfully run tests against.
        #
        # @since 6.1.1
        MIN_REQUIRED_VERSION = nil

        # Initialize the Test object.
        #
        # @example Create a test object
        #   Test.new(file, definition)
        #
        # @param [ String ] test_file The name of the test file.
        # @param [ Hash ] test_definition A hash corresponding to the parsed YAML containing the test definition.
        #
        # @since 6.1.1
        def initialize(test_file, test_definition)
          @test_file = test_file
          @description = test_definition.keys.first
          @skip = test_definition[description].select { |doc| doc['skip'] }.compact
          @definition = test_definition[description].select { |doc| !doc.key?('skip') }
          @definition.delete_if { |doc| doc['skip'] }
          @cached_values = {}
        end

        # Get the list of task groups in this test.
        #
        # @example
        #   test.task_groups
        #
        # @return [ Array<TaskGroup> ] The list of task groups.
        #
        # @since 6.1.1
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
        # @since 6.1.1
        def cache_value(cache_key, value)
          @cached_values["#{cache_key}"] = value
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
        # @since 6.1.1
        def get_cached_value(key)
          return key unless key.is_a?(String)
          @cached_values.fetch(key.gsub(/\$/, ''), key)
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
        # @since 6.1.1
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
        # @since 6.1.1
        def skip_test?(client, features_to_skip = test_file.skip_features)
          return false if @skip.empty?
          version_regexp = /(\d.\d.\d)( - )*(\d.\d.\d)*/
          @skip.collect { |s| s['skip'] }.any? do |skip|
            if version_regexp =~ skip['version']
              range = version_regexp.match(skip['version'])[1]..version_regexp.match(skip['version'])[3]
              range.cover?(client.info['version']['number'])
            else
              features_to_skip.include?(skip['features']) || skip['version'] == 'all'
            end
          end
        rescue
          warn('Could not determine Elasticsearch version')
        end

        private

        def meets_version_requirement?(version)
          version >= MIN_REQUIRED_VERSION && version <= MAX_REQUIRED_VERSION
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
