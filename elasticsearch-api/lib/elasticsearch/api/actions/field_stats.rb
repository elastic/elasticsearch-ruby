module Elasticsearch
  module API
    module Actions

      VALID_FIELD_STATS_PARAMS = [
        :fields,
        :level,
        :ignore_unavailable,
        :allow_no_indices,
        :expand_wildcards
      ].freeze

      # Returns statistical information about a field without executing a search.
      #
      # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
      # @option arguments [List] :fields A comma-separated list of fields for to get field statistics for (min value, max value, and more)
      # @option arguments [String] :level Defines if field stats should be returned on a per index level or on a cluster wide level (options: indices, cluster)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
      #
      # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/search-field-stats.html
      #
      def field_stats(arguments={})
        field_stats_request_for(arguments).body
      end

      def field_stats_request_for(arguments={})
        method = 'GET'
        path   = "_field_stats"
        params = Utils.__validate_and_extract_params arguments, VALID_FIELD_STATS_PARAMS
        body   = nil

        perform_request(method, path, params, body)
      end
    end
  end
end
