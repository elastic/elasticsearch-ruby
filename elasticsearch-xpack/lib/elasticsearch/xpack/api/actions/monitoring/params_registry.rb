# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Monitoring
        module Actions
          module ParamsRegistry
            extend self

            # A Mapping of all the actions to their list of valid params.
            #
            # @since 7.4.0
            PARAMS = {}

            # Register an action with its list of valid params.
            #
            # @example Register the action.
            #   ParamsRegistry.register(:benchmark, [ :verbose ])
            #
            # @param [ Symbol ] action The action to register.
            # @param [ Array[Symbol] ] valid_params The list of valid params.
            #
            # @since 7.4.0
            def register(action, valid_params)
              PARAMS[action.to_sym] = valid_params
            end

            # Get the list of valid params for a given action.
            #
            # @example Get the list of valid params.
            #   ParamsRegistry.get(:benchmark)
            #
            # @param [ Symbol ] action The action.
            #
            # @return [ Array<Symbol> ] The list of valid params for the action.
            #
            # @since 7.4.0
            def get(action)
              PARAMS.fetch(action, [])
            end
          end
        end
      end
    end
  end
end
