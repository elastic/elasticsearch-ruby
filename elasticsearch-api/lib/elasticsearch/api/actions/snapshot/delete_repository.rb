module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_DELETE_REPOSITORY_PARAMS = [
          :master_timeout,
          :timeout
        ].freeze

        # Delete a specific repository or repositories
        #
        # @example Delete the `my-backups` repository
        #
        #     client.snapshot.delete_repository repository: 'my-backups'
        #
        # @option arguments [List] :repository A comma-separated list of repository names (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def delete_repository(arguments={})
          delete_repository_request_for(arguments).body
        end

        def delete_repository_request_for(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]

          repository = arguments.delete(:repository)

          method = HTTP_DELETE
          path   = Utils.__pathify( '_snapshot', Utils.__listify(repository) )

          params = Utils.__validate_and_extract_params arguments, VALID_DELETE_REPOSITORY_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
