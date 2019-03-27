module Elasticsearch
  module API
    module Ingest
      module Actions

        # Return a specified pipeline
        #
        # @option arguments [String] :id Comma separated list of pipeline ids. Wildcards supported
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/plugins/current/ingest.html
        #
        def get_pipeline(arguments={})
          method = 'GET'
          path   = Utils.__pathify "_ingest/pipeline", Utils.__escape(arguments[:id])
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get_pipeline, [
            :master_timeout ].freeze)
      end
    end
  end
end
