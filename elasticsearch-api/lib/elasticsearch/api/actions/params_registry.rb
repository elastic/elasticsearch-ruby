module Elasticsearch
  module API
    module Actions
      module ParamsRegistry

        extend self

        # A Mapping of all the actions to their list of valid params.
        #
        # @since 6.2.0
        PARAMS = {}

        # Register an action with its list of valid params.
        #
        # @example Register the action.
        #   ParamsRegistry.register(:benchmark, [ :verbose ])
        #
        # @param [ Symbol ] action The action to register.
        # @param [ Array[Symbol] ] valid_params The list of valid params.
        #
        # @since 6.2.0
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
        # @since 6.2.0
        def get(action)
          PARAMS.fetch(action, [])
        end
      end
    end
  end
end
