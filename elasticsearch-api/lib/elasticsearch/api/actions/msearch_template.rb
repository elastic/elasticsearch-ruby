# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Allows to execute several search template operations in one request.
      #
      # @option arguments [List] :index A comma-separated list of index names to use as default
      # @option arguments [List] :type A comma-separated list of document types to use as default
      # @option arguments [String] :search_type Search operation type
      #   (options: query_then_fetch,query_and_fetch,dfs_query_then_fetch,dfs_query_and_fetch)

      # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
      # @option arguments [Number] :max_concurrent_searches Controls the maximum number of concurrent searches the multi search api will execute
      # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer or an object in the rest search response

      # @option arguments [Hash] :body The request definitions (metadata-search request definition pairs), separated by newlines (*Required*)
      #
      # *Deprecation notice*:
      # Specifying types in urls has been deprecated
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/search-multi-search.html
      #
      def msearch_template(arguments = {})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone

        _index = arguments.delete(:index)

        _type = arguments.delete(:type)

        method = Elasticsearch::API::HTTP_GET
        path   = if _index && _type
                   "#{Utils.__listify(_index)}/#{Utils.__listify(_type)}/_msearch/template"
                 elsif _index
                   "#{Utils.__listify(_index)}/_msearch/template"
                 else
                   "_msearch/template"
  end
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        case
        when body.is_a?(Array)
          payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
          payload << "" unless payload.empty?
          payload = payload.join("
")
        else
          payload = body
      end

        perform_request(method, path, params, payload, { "Content-Type" => "application/x-ndjson" }).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:msearch_template, [
        :search_type,
        :typed_keys,
        :max_concurrent_searches,
        :rest_total_hits_as_int
      ].freeze)
    end
    end
end
