module Elasticsearch
  module API
    module Cluster
      module Actions

        VALID_STATE_PARAMS = [
          :metric,
          :index_templates,
          :local,
          :master_timeout,
          :flat_settings,
          :expand_wildcards,
          :ignore_unavailable
        ].freeze

        # Get information about the cluster state (indices settings, allocations, etc)
        #
        # @example
        #
        #     client.cluster.state
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or omit to
        #                                 perform the operation on all indices
        # @option arguments [List] :metric Limit the information returned to the specified metrics
        #                                 (options: _all, blocks, index_templates, metadata, nodes, routing_table,
        #                                  master_node, version)
        # @option arguments [List] :index_templates A comma separated list to return specific index templates when
        #                                           returning metadata
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression for inidices
        #                                              (options: open, closed)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-state/
        #
        def state(arguments={})
          state_request_for(arguments).body
        end

        def state_request_for(arguments={})
          arguments = arguments.clone
          index     = arguments.delete(:index)
          metric    = arguments.delete(:metric)

          method = HTTP_GET
          path   = "_cluster/state"

          path   = Utils.__pathify '_cluster/state',
                                   Utils.__listify(metric),
                                   Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, VALID_STATE_PARAMS

          [:index_templates].each do |key|
            params[key] = Utils.__listify(params[key]) if params[key]
          end

          body = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
