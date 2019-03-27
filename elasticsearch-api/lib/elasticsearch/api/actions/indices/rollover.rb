module Elasticsearch
  module API
    module Indices
      module Actions

        # The rollover index API rolls an alias over to a new index when the existing index
        # is considered to be too large or too old
        #
        # @option arguments [String] :alias The name of the alias to rollover (*Required*)
        # @option arguments [String] :new_index The name of the rollover index
        # @option arguments [Hash] :body The conditions that needs to be met for executing rollover
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :dry_run If set to true the rollover action will only be validated but not actually performed even if a condition matches. The default is false
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the newly created rollover index before the operation returns.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-rollover-index.html
        #
        def rollover(arguments={})
          raise ArgumentError, "Required argument 'alias' missing" unless arguments[:alias]
          arguments = arguments.clone
          source = arguments.delete(:alias)
          target = arguments.delete(:new_index)
          method = HTTP_POST
          path   = Utils.__pathify Utils.__escape(source), '_rollover', Utils.__escape(target)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:rollover, [
            :timeout,
            :dry_run,
            :master_timeout,
            :wait_for_active_shards,
            :include_type_name ].freeze)
      end
    end
  end
end
