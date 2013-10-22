module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns statistical information about nodes in the cluster.
        #
        # @example Return statistics about JVM
        #
        #     client.cluster.node_stats clear: true, jvm: true
        #
        # @option arguments [List] :metric Limit the information returned for `indices` family to a specific metric
        #                                  (options: docs, fielddata, filter_cache, flush, get, id_cache, indexing, merges,
        #                                  refresh, search, store, warmer)
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information;
        #                                   use `_local` to return information from the node you're connecting to, leave
        #                                   empty to get information from all nodes
        # @option arguments [Boolean] :all Return all available information
        # @option arguments [Boolean] :clear Reset the default level of detail
        # @option arguments [List] :fields A comma-separated list of fields for `fielddata` metric (supports wildcards)
        # @option arguments [Boolean] :fs Return information about the filesystem
        # @option arguments [Boolean] :http Return information about HTTP
        # @option arguments [Boolean] :indices Return information about indices
        # @option arguments [Boolean] :jvm Return information about the JVM
        # @option arguments [Boolean] :network Return information about network
        # @option arguments [Boolean] :os Return information about the operating system
        # @option arguments [Boolean] :process Return information about the Elasticsearch process
        # @option arguments [Boolean] :thread_pool Return information about the thread pool
        # @option arguments [Boolean] :transport Return information about transport
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-nodes-stats/
        #
        def node_stats(arguments={})
          method = 'GET'

          case
            # Field data metric for the `indices` metric family
            when arguments[:indices] && arguments[:metric] == 'fielddata'
              path   = Utils.__pathify '_nodes', Utils.__listify(arguments[:node_id]), 'stats/indices/fielddata'
              params = { :fields => Utils.__listify(arguments[:fields]) }

            # `indices` metric family incl. a metric
            when arguments[:indices] && arguments[:metric]
              path   = Utils.__pathify( '_nodes', Utils.__listify(arguments[:node_id]), 'stats/indices', arguments[:metric] )
              params = {}

            else
              path   = Utils.__pathify( '_nodes', Utils.__listify(arguments[:node_id]), 'stats' )

              params = arguments.select do |k,v|
                [ :all,
                  :clear,
                  :fields,
                  :fs,
                  :http,
                  :indices,
                  :jvm,
                  :network,
                  :os,
                  :process,
                  :thread_pool,
                  :transport ].include?(k)
              end
              # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
              params = Hash[params] unless params.is_a?(Hash)

              params[:fields] = Utils.__listify(params[:fields]) if params[:fields]
          end

          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
