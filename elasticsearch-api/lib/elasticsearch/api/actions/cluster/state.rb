module Elasticsearch
  module API
    module Cluster
      module Actions

        # Get information about the cluster state (indices settings, allocations, etc)
        #
        # @example
        #
        #     client.cluster.state
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform
        #   the operation on all indices
        # @option arguments [List] :metric Limit the information returned to the specified metrics
        #   (options: _all,blocks,metadata,nodes,routing_table,routing_nodes,master_node,version)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #   (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Number] :wait_for_metadata_version Wait for the metadata version to be equal or greater
        #   than the specified metadata version
        # @option arguments [Time] :wait_for_timeout The maximum time to wait for wait_for_metadata_version before
        #   timing out
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #   unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves
        #   into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #   are open, closed or both. (options: open, closed, none, all)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-state/
        #
        def state(arguments={})
          arguments = arguments.clone
          index     = arguments.delete(:index)
          metric    = arguments.delete(:metric)
          method = HTTP_GET
          path   = Utils.__pathify '_cluster/state',
                                   Utils.__listify(metric),
                                   Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          [:index_templates].each do |key|
            params[key] = Utils.__listify(params[key]) if params[key]
          end

          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:state, [
            :local,
            :master_timeout,
            :flat_settings,
            :wait_for_metadata_version,
            :wait_for_timeout,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards ].freeze)
      end
    end
  end
end
