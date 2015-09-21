module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_DELETE_PARAMS = [ :master_timeout ].freeze

        # Delete a snapshot from the repository
        #
        # @note Will also abort a currently running snapshot.
        #
        # @example Delete the `snapshot-1` snapshot
        #
        #     client.snapshot.delete repository: 'my-backups', snapshot: 'snapshot-1'
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [String] :snapshot A snapshot name (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def delete(arguments={})
          delete_request_for(arguments).body
        end

        def delete_request_for(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing"   unless arguments[:snapshot]

          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_DELETE
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__listify(snapshot) )

          params = Utils.__validate_and_extract_params arguments, VALID_DELETE_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
