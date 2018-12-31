module Elasticsearch

  module RestAPIYAMLTests

    class TestFile

      class Test

        attr_reader :description
        attr_reader :test_file
        attr_reader :cached_values

        def initialize(test_file, test_definition)
          @test_file = test_file
          @description = test_definition.keys.first
          @definition = test_definition[description]
          @cached_values = {}
        end

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

              task_groups[-1].add_action(action)
              task_groups
            end
          end
        end

        def cache_variable(variable, value)
          @cached_values["$#{variable}"] = value
        end

        def run(client)
          task_groups.each { |task_group| task_group.run(client) }
        end

        def is_a_validation?(action)
          action['gt'] || action['set'] || action['match'] || action['is_false'] || action['is_true'] || (action['do'] && action['do']['catch'])
        end
      end
    end
  end
end