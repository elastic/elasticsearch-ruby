module Elasticsearch
  module API
    module Ingest
      module Actions

        # Extracts structured fields out of a single text field within a document. You choose which field to extract
        #   matched fields from, as well as the grok pattern you expect will match.
        #
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/plugins/current/ingest.html
        #
        def processor_grok(arguments={})
          method = Elasticsearch::API::HTTP_GET
          path   = "_ingest/processor/grok"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:processor_grok, [
        ].freeze)
      end
    end
  end
end
