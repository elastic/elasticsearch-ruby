module Elasticsearch
  module API
    module Actions

      # Execute several search requests using templates (inline, indexed or stored in a file)
      #
      # @example Search with an inline script
      #
      #     client.msearch_template body: [
      #       { index: 'test' },
      #       { inline: { query: { match: { title: '{{q}}' } } }, params: { q: 'foo'} }
      #     ]
      #
      # @option arguments [List] :index A comma-separated list of index names to use as default
      # @option arguments [List] :type A comma-separated list of document types to use as default
      # @option arguments [Hash] :body The request definitions (metadata-search request definition pairs), separated by newlines (*Required*)
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, query_and_fetch, dfs_query_then_fetch, dfs_query_and_fetch)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-search-template.html
      #
      def msearch_template(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        valid_params = [ :search_type ]
        method = HTTP_GET
        path   = Utils.__pathify Utils.__listify(arguments[:index]),
                                 Utils.__listify(arguments[:type]),
                                 '_msearch/template'
        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        case
          when body.is_a?(Array)
            payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          else
            payload = body
        end

        perform_request(method, path, params, payload).body
      end
    end
  end
end
