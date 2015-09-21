module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_STATUS_PARAMS = [ :master_timeout ].freeze

        # Return information about a running snapshot
        #
        # @example Return information about all currently running snapshots
        #
        #     client.snapshot.status repository: 'my-backups', human: true
        #
        # @example Return information about a specific snapshot
        #
        #     client.snapshot.status repository: 'my-backups', human: true
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [List] :snapshot A comma-separated list of snapshot names
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html#_snapshot_status
        #
        def status(arguments={})
          status_request_for(arguments).body
        end

        def status_request_for(arguments={})
          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_GET

          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__escape(snapshot), '_status')
          params = Utils.__validate_and_extract_params arguments, VALID_STATUS_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
