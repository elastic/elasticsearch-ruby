# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions

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
        method = 'GET'
        path   = Utils.__pathify Utils.__escape(arguments[:index]), "_field_stats"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:field_stats, [
          :fields,
          :level,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards ].freeze)
    end
  end
end
