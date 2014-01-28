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
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or omit to
        #                                 perform the operation on all indices
        # @option arguments [List] :metric Limit the information returned to the specified metrics
        #                                 (options: _all, blocks, index_templates, metadata, nodes, routing_table)
        # @option arguments [List] :index_templates A comma separated list to return specific index templates when
        #                                           returning metadata
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-state/
        #
        def state(arguments={})
          arguments = arguments.clone
          index     = arguments.delete(:index)
          metric    = arguments.delete(:metric)

          valid_params = [
            :metric,
            :index_templates,
            :local,
            :master_timeout,
            :flat_settings ]

          method = 'GET'
          path   = "_cluster/state"

          path   = Utils.__pathify '_cluster/state',
                                   Utils.__listify(metric),
                                   Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, valid_params

          [:index_templates].each do |key|
            params[key] = Utils.__listify(params[key]) if params[key]
          end

          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
