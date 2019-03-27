module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns a list of any cluster-level changes (e.g. create index, update mapping, allocate or fail shard)
        # which have not yet been executed and are queued up.
        #
        # @example Get a list of currently queued up tasks in the cluster
        #
        #     client.cluster.pending_tasks
        #
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cluster-pending.html
        #
        def pending_tasks(arguments={})
          method = HTTP_GET
          path   = "_cluster/pending_tasks"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:pending_tasks, [
            :local,
            :master_timeout ].freeze)
      end
    end
  end
end
