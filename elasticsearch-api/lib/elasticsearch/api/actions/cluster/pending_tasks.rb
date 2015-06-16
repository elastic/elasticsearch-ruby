module Elasticsearch
  module API
    module Cluster
      module Actions

        VALID_PENDINGS_TASKS_PARAMS = [
          :local,
          :master_timeout
        ].freeze

        # Returns a list of any cluster-level changes (e.g. create index, update mapping, allocate or fail shard)
        # which have not yet been executed and are queued up.
        #
        # @example Get a list of currently queued up tasks in the cluster
        #
        #     client.cluster.pending_tasks
        #
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/cluster-pending.html
        #
        def pending_tasks(arguments={})
          pending_tasks_request_for(arguments).body
        end

        def pending_tasks_request_for(arguments={})
          method = HTTP_GET
          path   = "/_cluster/pending_tasks"
          params = Utils.__validate_and_extract_params arguments, VALID_PENDINGS_TASKS_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
