module Elasticsearch
  module API
    module Indices
      module Actions

        # Copy an existing index into a new index with a fewer number of primary shards
        #
        # @option arguments [String] :index The name of the source index to shrink (*Required*)
        # @option arguments [String] :target The name of the target index to shrink into (*Required*)
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        # @option arguments [Boolean] :copy_settings whether or not to copy settings from the source index (defaults to false)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the shrunken index before the operation returns.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-shrink-index.html
        #
        def shrink(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]
          arguments = arguments.clone
          source = arguments.delete(:index)
          target = arguments.delete(:target)

          method = HTTP_PUT
          path   = Utils.__pathify(source, '_shrink', target)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:shrink, [
            :copy_settings,
            :timeout,
            :master_timeout,
            :wait_for_active_shards ].freeze)
      end
    end
  end
end
