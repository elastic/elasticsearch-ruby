# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns information about why a specific matches (or doesn't match) a query.
      #
      # @option arguments [String] :id The document ID
      # @option arguments [String] :index The name of the index
      # @option arguments [Boolean] :analyze_wildcard Specify whether wildcards and prefix queries in the query string query should be analyzed (default: false)
      # @option arguments [String] :analyzer The analyzer for the query string query
      # @option arguments [String] :default_operator The default operator for query string query (AND or OR)
      #   (options: AND,OR)

      # @option arguments [String] :df The default field for query string query (default: _all)
      # @option arguments [List] :stored_fields A comma-separated list of stored fields to return in the response
      # @option arguments [Boolean] :lenient Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [String] :q Query in the Lucene query string syntax
      # @option arguments [String] :routing Specific routing value
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The query definition using the Query DSL
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/search-explain.html
      #
      def explain(arguments = {})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_GET
        path   = "#{Utils.__listify(_index)}/_explain/#{Utils.__listify(_id)}"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        perform_request(method, path, params, body, headers).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:explain, [
        :analyze_wildcard,
        :analyzer,
        :default_operator,
        :df,
        :stored_fields,
        :lenient,
        :preference,
        :q,
        :routing,
        :_source,
        :_source_excludes,
        :_source_includes
      ].freeze)
    end
    end
end
