module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns information about the hottest threads in the cluster or on a specific node as a String.
        #
        #
        # The information is returned as text, and allows you to understand what are currently
        # the most taxing operations happening in the cluster, for debugging or monitoring purposes.
        #
        # @example Return 10 hottest threads
        #
        #     client.cluster.node_hot_threads threads: 10
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information;
        #                                   use `_local` to return information from the node you're connecting to,
        #                                   leave empty to get information from all nodes
        # @option arguments [Time] :interval The interval for the second sampling of threads
        # @option arguments [Number] :snapshots Number of samples of thread stacktrace (default: 10)
        # @option arguments [Number] :threads Specify the number of threads to provide information for (default: 3)
        # @option arguments [String] :type The type to sample (default: cpu) (options: cpu, wait, block)
        #
        # @return [String]
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-cluster-nodes-hot-threads/
        #
        def node_hot_threads(arguments={})
          method = 'GET'
          path   = "_cluster/nodes/#{arguments[:node_id]}/hot_threads".squeeze('/')
          path   = Utils.__pathify '_cluster/nodes', Utils.__listify(arguments[:node_id]), 'hot_threads'
          params = arguments.select do |k,v|
            [ :interval,
              :snapshots,
              :threads,
              :type ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
