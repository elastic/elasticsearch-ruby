module Elasticsearch
  module API
    module Ingest
      module Actions

        # Delete a speficied pipeline
        #
        # @option arguments [String] :id Pipeline ID (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/plugins/current/ingest.html
        #
        def delete_pipeline(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          method = 'DELETE'
          path   = Utils.__pathify "_ingest/pipeline", Utils.__escape(arguments[:id])
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete_pipeline, [
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
