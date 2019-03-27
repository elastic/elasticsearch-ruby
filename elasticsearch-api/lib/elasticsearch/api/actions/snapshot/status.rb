module Elasticsearch
  module API
    module Snapshot
      module Actions

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
        # @option arguments [Boolean] :ignore_unavailable Whether to ignore unavailable snapshots, defaults to false which means a SnapshotMissingException is thrown
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
        #
        def status(arguments={})
          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_GET

          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__escape(snapshot), '_status')
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:status, [
            :master_timeout,
            :ignore_unavailable ].freeze)
      end
    end
  end
end
