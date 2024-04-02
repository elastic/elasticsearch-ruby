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

require 'base64'

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
        # @since 6.2.0
        class TaskGroup
          attr_reader :exception, :response, :test

          # Initialize a TaskGroup object.
          #
          # @example Create a TaskGroup
          #   TaskGroup.new(test)
          #
          # @param [ Test ] test The test this task group is part of.
          #
          # @since 6.2.0
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
          # @since 6.2.0
          def add_action(action)
            @actions << action if ACTIONS.any? { |a| action[a] }
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
          # @since 6.2.0
          def run(client)
            # Allow the actions to be execute only once.
            return if @executed
            @executed = true

            do_actions.inject(client) do |_client, action|
              action.execute(_client, test)
              # Cache the result of the action, if a set action is defined.
              set_variable(action)
              transform_and_set_variable(action)
              _client
            end
            self
          rescue => ex
            raise ex unless catch_exception?
            # Cache the exception raised as a result of the operation, if the task group has a 'catch' defined.
            @exception = ex
          end

          # Consider the response of interest the one resulting from the last action.
          #
          # @return [ Hash ] The response from the last action.
          #
          # @since 6.2.0
          def response
            @response ||= begin
              if do_actions.any? { |a| a.yaml_response? }
                YAML.load(do_actions[-1].response.body)
              else
                do_actions[-1].response
              end
            end
          end

          # Does this task group expect to raise an exception for an action?
          #
          # @return [ true, false ] If the task group contains an action expected to raise an exception.
          #
          # @since 6.2.0
          def catch_exception?
            !!expected_exception_message
          end

          # Does this task group have match clauses.
          #
          # @return [ true, false ] If the task group has match clauses.
          #
          # @since 6.2.0
          def has_match_clauses?
            !!match_clauses
          end

          # Does this task group have match clauses on field value length.
          #
          # @return [ true, false ] If the task group has match clauses on field value length.
          #
          # @since 6.2.0
          def has_length_match_clauses?
            !!length_match_clauses
          end

          # Does this task group have match clauses on a field value being true.
          #
          # @return [ true, false ] If the task group has match clauses on a field value being true.
          #
          # @since 6.2.0
          def has_true_clauses?
            !!true_clauses
          end

          # Does this task group have match clauses on a field value being false.
          #
          # @return [ true, false ] If the task group has match clauses on a field value being false.
          #
          # @since 6.2.0
          def has_false_clauses?
            !!false_clauses
          end

          # Does this task group have clauses on a field value being gte.
          #
          # @return [ true, false ] If the task group has clauses on a field value being gte.
          #
          # @since 6.2.0
          def has_gte_clauses?
            !!gte_clauses
          end

          # Does this task group have clauses on a field value being gt.
          #
          # @return [ true, false ] If the task group has clauses on a field value being gt.
          #
          # @since 6.2.0
          def has_gt_clauses?
            !!gt_clauses
          end

          # Does this task group have clauses on a field value being lte.
          #
          # @return [ true, false ] If the task group has clauses on a field value being lte.
          #
          # @since 6.2.0
          def has_lte_clauses?
            !!lte_clauses
          end

          # Does this task group have clauses on a field value being lt.
          #
          # @return [ true, false ] If the task group has clauses on a field value being lt.
          #
          # @since 6.2.0
          def has_lt_clauses?
            !!lt_clauses
          end

          # The expected exception message.
          #
          # @return [ String ] The expected exception message.
          #
          # @since 6.2.0
          def expected_exception_message
            @expected_exception_message ||= begin
              if do_definitions =  @actions.group_by { |a| a.keys.first }['do']
                if catch_exception = do_definitions.find { |a| a['do']['catch'] }
                  catch_exception['do']['catch']
                end
              end
            end
          end

          # The match clauses.
          #
          # @return [ Array<Hash> ] The match clauses.
          #
          # @since 6.2.0
          def match_clauses
            @match_actions ||= @actions.group_by { |a| a.keys.first }['match']
          end

          # The true match clauses.
          #
          # @return [ Array<Hash> ] The true match clauses.
          #
          # @since 6.2.0
          def true_clauses
            @true_clauses ||= @actions.group_by { |a| a.keys.first }['is_true']
          end

          # The false match clauses.
          #
          # @return [ Array<Hash> ] The false match clauses.
          #
          # @since 6.2.0
          def false_clauses
            @false_clauses ||= @actions.group_by { |a| a.keys.first }['is_false']
          end

          # The gte clauses.
          #
          # @return [ Array<Hash> ] The gte clauses.
          #
          # @since 6.2.0
          def gte_clauses
            @gte_clauses ||= @actions.group_by { |a| a.keys.first }['gte']
          end

          # The gt clauses.
          #
          # @return [ Array<Hash> ] The gt clauses.
          #
          # @since 6.2.0
          def gt_clauses
            @gt_clauses ||= @actions.group_by { |a| a.keys.first }['gt']
          end

          # The lte clauses.
          #
          # @return [ Array<Hash> ] The lte clauses.
          #
          # @since 6.2.0
          def lte_clauses
            @lte_clauses ||= @actions.group_by { |a| a.keys.first }['lte']
          end

          # The lt clauses.
          #
          # @return [ Array<Hash> ] The lt clauses.
          #
          # @since 6.2.0
          def lt_clauses
            @lt_clauses ||= @actions.group_by { |a| a.keys.first }['lt']
          end

          # The field length match clauses.
          #
          # @return [ Array<Hash> ] The field length match clauses.
          #
          # @since 6.2.0
          def length_match_clauses
            @match_length ||= @actions.group_by { |a| a.keys.first }['length']
          end

          private

          ACTIONS = (Test::GROUP_TERMINATORS + ['do']).freeze

          def do_actions
            return [] if @actions.empty?
            @do_actions ||= @actions.group_by { |a| a.keys.first }['do'].map { |definition| Action.new(definition['do']) }
          end

          def variables_to_set
            @variables_to_set ||= (@actions.group_by { |a| a.keys.first }['set'] || [])
          end

          def variables_to_transform_and_set
            @variables_to_transform_and_set ||= (@actions.group_by { |a| a.keys.first }['transform_and_set'] || [])
          end

          def transform_and_set_variable(action)
            variables_to_transform_and_set.each do |set_definition|
              set_definition['transform_and_set'].each do |response_key, transform_description|
                match_base_64_transform = /(\#base64EncodeCredentials\()(\S*)\)/
                matches = match_base_64_transform.match(transform_description)
                fields = matches[2].split(',') if matches.length > 0

                values_to_encode = action.response.select do |key|
                  fields.include?(key)
                end.values if fields

                to_set = Base64.strict_encode64(values_to_encode.join(':'))
                @test.cache_value(response_key, to_set)
              end
            end
          end

          def set_variable(action)
            variables_to_set.each do |set_definition|
              set_definition['set'].each do |response_key, variable_name|
                nested_key_chain = response_key.split('.').map do |key|
                  # If there's a variable in the set key, get the value:
                  if key.match?(/\$.+/)
                    value = @test.cached_values[key.gsub('$', '')]
                    key.gsub!(key, value) if value
                  end

                  (key =~ /\A[-+]?[0-9]+\z/) ? key.to_i: key
                end

                if to_set = find_value(nested_key_chain, action.response)
                  @test.cache_value(variable_name, to_set)
                end
              end
            end
          end

          def find_value(chain, document)
            # Return the first key if an 'arbitrary key' should be returned
            return document.keys[0] if chain[0] == '_arbitrary_key_'
            return document[chain[0]] unless chain.size > 1
            find_value(chain[1..-1], document[chain[0]]) if document[chain[0]]
          end
        end
      end
    end
  end
end
