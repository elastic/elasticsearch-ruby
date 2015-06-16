module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_GET_REPOSITORY_PARAMS = [
          :master_timeout,
          :local
        ].freeze

        # Get information about snapshot repositories or a specific repository
        #
        # @example Get all repositories
        #
        #     client.snapshot.get_repository
        #
        # @example Get a specific repository
        #
        #     client.snapshot.get_repository repository: 'my-backups'
        #
        # @option arguments [List] :repository A comma-separated list of repository names. Leave blank or use `_all`
        #                                      to get a list of repositories
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def get_repository(arguments={})
          get_repository_request_for(arguments).body
        end

        def get_repository_request_for(arguments={})
          repository = arguments.delete(:repository)

          method = HTTP_GET
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository) )

          params = Utils.__validate_and_extract_params arguments, VALID_GET_REPOSITORY_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
