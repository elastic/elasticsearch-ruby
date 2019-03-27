module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Create a repository for storing snapshots
        #
        # @example Create a repository at `/tmp/backup`
        #
        #     client.snapshot.create_repository repository: 'my-backups',
        #                                       body: {
        #                                         type: 'fs',
        #                                         settings: { location: '/tmp/backup', compress: true  }
        #                                       }
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [Hash] :body The repository definition (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :verify Whether to verify the repository after creation
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
        #
        def create_repository(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'body' missing"       unless arguments[:body]
          repository = arguments.delete(:repository)

          method = HTTP_PUT
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository) )

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:create_repository, [
            :master_timeout,
            :timeout,
            :verify ].freeze)
      end
    end
  end
end
