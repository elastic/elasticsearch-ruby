module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns information about nodes in the cluster (cluster settings, JVM version, etc).
        #
        # Use the `all` option to return all available settings, or limit the information returned
        # to a specific type (eg. `http`).
        #
        # Use the `node_id` option to limit information to specific node(s).
        #
        # @example Return information about JVM
        #
        #     client.cluster.node_info jvm: true
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information;
        #                                   use `_local` to return information from the node you're connecting to, leave
        #                                   empty to get information from all nodes
        # @option arguments [Boolean] :all Return all available information
        # @option arguments [Boolean] :clear Reset the default settings
        # @option arguments [Boolean] :http Return information about HTTP
        # @option arguments [Boolean] :jvm Return information about the JVM
        # @option arguments [Boolean] :network Return information about network
        # @option arguments [Boolean] :os Return information about the operating system
        # @option arguments [Boolean] :plugin Return information about plugins
        # @option arguments [Boolean] :process Return information about the Elasticsearch process
        # @option arguments [Boolean] :settings Return information about node settings
        # @option arguments [Boolean] :thread_pool Return information about the thread pool
        # @option arguments [Boolean] :transport Return information about transport
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-nodes-info/
        #
        def node_info(arguments={})
          method = 'GET'
          path   = Utils.__pathify( '_cluster/nodes', Utils.__listify(arguments[:node_id]) )
          params = arguments.select do |k,v|
            [ :all,
              :clear,
              :http,
              :jvm,
              :network,
              :os,
              :plugin,
              :process,
              :settings,
              :thread_pool,
              :transport ].include?(k)
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
