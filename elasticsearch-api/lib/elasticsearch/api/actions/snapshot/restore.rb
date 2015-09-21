module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_RESTORE_PARAMS = [
          :master_timeout,
          :wait_for_completion
        ].freeze

        # Restore the state from a snapshot
        #
        # @example Restore from the `snapshot-1` snapshot
        #
        #     client.snapshot.restore repository: 'my-backups', snapshot: 'snapshot-1'
        #
        # @example Restore a specific index under a different name
        #
        #     client.snapshot.restore repository: 'my-backups',
        #                             snapshot: 'snapshot-1',
        #                             body: {
        #                               rename_pattern: "^(.*)$",
        #                               rename_replacement: "restored_$1"
        #                             }
        #
        # @note You cannot restore into an open index, you have to {Indices::Actions#close} it first
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [String] :snapshot A snapshot name (*Required*)
        # @option arguments [Hash] :body Details of what to restore
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :wait_for_completion Should this request wait until the operation has completed before returning
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def restore(arguments={})
          restore_request_for(arguments).body
        end

        def restore_request_for(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing"   unless arguments[:snapshot]

          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_POST
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__escape(snapshot), '_restore' )

          params = Utils.__validate_and_extract_params arguments, VALID_RESTORE_PARAMS
          body   = arguments[:body]

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
