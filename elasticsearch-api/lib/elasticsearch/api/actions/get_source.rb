module Elasticsearch
  module API
    module Actions

      VALID_GET_SOURCE_PARAMS = [
        :fields,
        :parent,
        :preference,
        :realtime,
        :refresh,
        :routing,
        :_source,
        :_source_include,
        :_source_exclude
      ].freeze

      # Return a specified document's `_source`.
      #
      # The response contains just the original document, as passed to Elasticsearch during indexing.
      #
      # @example Get a document `_source`
      #
      #     client.get_source index: 'myindex', type: 'mytype', id: '1'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [Number,List] :ignore The list of HTTP errors to ignore; only `404` supported at the moment
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document; use `_all` to fetch the first document
      #                                  matching the ID across all types) (*Required*)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :_source Specify whether the _source field should be returned,
      #                                     or a list of fields to return
      # @option arguments [String] :_source_exclude A list of fields to exclude from the returned _source field
      # @option arguments [String] :_source_include A list of fields to extract and return from the _source field
      #
      # @see http://elasticsearch.org/guide/reference/api/get/
      #
      # @since 0.90.1
      #
      def get_source(arguments={})
        Utils.__rescue_from_not_found do
          get_source_request_for(arguments).body
        end
      end

      def get_source_request_for(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        arguments[:type] ||= UNDERSCORE_ALL

        method = HTTP_GET
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id]),
                                 '_source'

        params = Utils.__validate_and_extract_params arguments, VALID_GET_SOURCE_PARAMS
        body   = nil

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        perform_request(method, path, params, body)
      end
    end
  end
end
