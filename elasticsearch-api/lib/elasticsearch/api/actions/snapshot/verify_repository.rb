module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_VERIFY_REPOSITORY_PARAMS = [
          :repository,
          :master_timeout,
          :timeout
        ].freeze

        # Explicitly perform the verification of a repository
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def verify_repository(arguments={})
          verify_repository_request_for(arguments).body
        end

        def verify_repository_request_for(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]

          repository = arguments.delete(:repository)
          method = HTTP_POST
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), '_verify' )
          params = Utils.__validate_and_extract_params arguments, VALID_VERIFY_REPOSITORY_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
