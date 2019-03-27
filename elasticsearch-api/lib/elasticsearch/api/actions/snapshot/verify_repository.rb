module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Explicitly perform the verification of a repository
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
        #
        def verify_repository(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          repository = arguments.delete(:repository)
          method = HTTP_POST
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), '_verify' )
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:verify_repository, [
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
