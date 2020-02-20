# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Allows to retrieve a large numbers of results from a single search request.
      #
      # @option arguments [String] :scroll_id The scroll ID   *Deprecated*
      # @option arguments [Time] :scroll Specify how long a consistent view of the index should be maintained for scrolled search
      # @option arguments [String] :scroll_id The scroll ID for scrolled search
      # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer or an object in the rest search response

      # @option arguments [Hash] :body The scroll ID if not passed by URL or query parameter.
      #
      # *Deprecation notice*:
      # A scroll id can be quite large and should be specified as part of the body
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/search-request-body.html#request-body-search-scroll
      #
      def scroll(arguments = {})
        arguments = arguments.clone

        _scroll_id = arguments.delete(:scroll_id)

        method = Elasticsearch::API::HTTP_GET
        path   = if _scroll_id
                   "_search/scroll/#{Utils.__listify(_scroll_id)}"
                 else
                   "_search/scroll"
end
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:scroll, [
        :scroll,
        :scroll_id,
        :rest_total_hits_as_int
      ].freeze)
    end
    end
end
