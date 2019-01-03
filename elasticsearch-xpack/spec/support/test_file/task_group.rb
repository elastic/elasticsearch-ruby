module Elasticsearch

  module RestAPIYAMLTests

    class TestFile

      class Test

        # Representation of a block of actions consisting of some 'do' actions and their verifications.
        #
        # For example, this is a task group:
        #
        #   - do:
        #       xpack.security.get_role:
        #         name: "admin_role"
        #   - match: { admin_role.cluster.0:  "all" }
        #   - match: { admin_role.metadata.key1:  "val1" }
        #   - match: { admin_role.metadata.key2:  "val2" }
        #
        # @since 6.1.1
        class TaskGroup

          attr_reader :exception
          attr_reader :response
          attr_reader :test

          # Initialize a TaskGroup object.
          #
          # @example Create a TaskGroup
          #   TaskGroup.new(test)
          #
          # @param [ Test ] test The test this task group is part of.
          #
          # @since 6.1.1
          def initialize(test)
            @actions = []
            @exception = nil
            @response = nil
            @variables = {}
            @test = test
          end

          # Add an action to the task group definition.
          #
          # @example Add an action
          #   task_group.add_action(action)
          #
          # @param [ Hash ] action The hash representation of an action.
          #
          # @return [ self ]
          #
          # @since 6.1.1
          def add_action(action)
            @actions << action if action['do'] || action['match'] || action['length'] || action['set']
            self
          end

          # Run the actions in the task group.
          #
          # @example Run the actions
          #   task_group.run(client)
          #
          # @param [ Elasticsearch::Client ] client The client to use to run the actions.
          #
          # @return [ self ]
          #
          # @since 6.1.1
          def run(client)
            do_actions.inject(client) do |_client, action|
              action.execute(_client, test)
              # Cache the result of the action, if a set action is defined.
              set_variable(action)
              _client
            end
            self
          rescue => ex
            raise ex unless catch_exception?
            # Cache the exception raised as a result of the operation, if the task group has a 'catch' defined.
            @exception = ex
          end

          # Consider the response from the last action the response of interest.
          #
          # @return [ Hash ] The response from the last action.
          #
          # @since 6.1.1
          def response
            do_actions[-1].response
          end

          # Does this task group expect to raise an exception for an action?
          #
          # @return [ true, false ] If the task group contains an action expected to raise an exception.
          #
          # @since 6.1.1
          def catch_exception?
            !!expected_exception_message
          end

          # Does this task group have match clauses.
          #
          # @return [ true, false ] If the task group has match clauses.
          #
          # @since 6.1.1
          def has_match_clauses?
            !!match_clauses
          end

          # Does this task group have match clauses on field value length.
          #
          # @return [ true, false ] If the task group has match clauses on field value length.
          #
          # @since 6.1.1
          def has_length_match_clauses?
            !!length_match_clauses
          end

          # The expected exception message.
          #
          # @return [ String ] The expected exception message.
          #
          # @since 6.1.1
          def expected_exception_message
            if catch_exception = @actions.group_by { |a| a.keys.first }['do'].find { |a| a['do']['catch'] }
              catch_exception['do']['catch']
            end
          end

          # The match clauses.
          #
          # @return [ Array<Hash> ] The match clauses.
          #
          # @since 6.1.1
          def match_clauses
            @match_actions ||= @actions.group_by { |a| a.keys.first }['match']
          end

          # The field length match clauses.
          #
          # @return [ Array<Hash> ] The field length match clauses.
          #
          # @since 6.1.1
          def length_match_clauses
            @match_length ||= @actions.group_by { |a| a.keys.first }['length']
          end

          private

          def do_actions
            @do_actions ||= @actions.group_by { |a| a.keys.first }['do'].map { |definition| Action.new(definition['do']) }
          end

          def variables_to_set
            @actions.group_by { |a| a.keys.first }['set'] || []
          end

          def set_variable(action)
            variables_to_set.each do |set_definition|
              set_definition['set'].each do |response_key, variable_name|

                nested_key_chain = response_key.split('.').map do |key|
                  (key =~ /\A[-+]?[0-9]+\z/) ? key.to_i: key
                end

                if to_set = find_value(nested_key_chain, action.response)
                  @test.cache_value(variable_name, to_set)
                end
              end
            end
          end

          def find_value(chain, document)
            return document[chain[0]] unless chain.size > 1
            find_value(chain[1..-1], document[chain[0]]) if document[chain[0]]
          end
        end
      end
    end
  end
end