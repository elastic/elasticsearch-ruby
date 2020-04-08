# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns information about whether a document exists in an index.
      #
      # @option arguments [String] :id The document ID
      # @option arguments [String] :index The name of the index
      # @option arguments [List] :stored_fields A comma-separated list of stored fields to return in the response
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type
      #   (options: internal,external,external_gte)

      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-get.html
      #
      def exists(arguments = {})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_HEAD
        path   = "#{Utils.__listify(_index)}/_doc/#{Utils.__listify(_id)}"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = nil

        Utils.__rescue_from_not_found do
          perform_request(method, path, params, body, headers).status == 200 ? true : false
        end
      end

      alias_method :exists?, :exists
      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:exists, [
        :stored_fields,
        :preference,
        :realtime,
        :refresh,
        :routing,
        :_source,
        :_source_excludes,
        :_source_includes,
        :version,
        :version_type
      ].freeze)
    end
    end
end
