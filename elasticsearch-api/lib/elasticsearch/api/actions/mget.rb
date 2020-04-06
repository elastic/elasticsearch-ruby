# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Allows to get multiple documents in one request.
      #
      # @option arguments [String] :index The name of the index
      # @option arguments [List] :stored_fields A comma-separated list of stored fields to return in the response
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field

      # @option arguments [Hash] :body Document identifiers; can be either `docs` (containing full document information) or `ids` (when index is provided in the URL. (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-multi-get.html
      #
      def mget(arguments = {})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_GET
        path   = if _index
                   "#{Utils.__listify(_index)}/_mget"
                 else
                   "_mget"
  end
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:mget, [
        :stored_fields,
        :preference,
        :realtime,
        :refresh,
        :routing,
        :_source,
        :_source_excludes,
        :_source_includes
      ].freeze)
    end
    end
end
