module Elasticsearch
  module API
    module Indices
      module Actions

        # Return information about segments for one or more indices.
        #
        # The response contains information about segment size, number of documents, deleted documents, etc.
        # See also {Indices::Actions#optimize}.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Boolean] :verbose Includes detailed memory usage by Lucene.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-segments.html
        #
        def segments(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_segments'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:segments, [
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :verbose ].freeze)
      end
    end
  end
end
