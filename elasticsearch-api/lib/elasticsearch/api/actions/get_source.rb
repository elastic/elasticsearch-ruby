module Elasticsearch
  module API
    module Actions

      # Return a specified document's `_source`.
      #
      # The response contains just the original document, as passed to Elasticsearch during indexing.
      #
      # @example Get a document `_source`
      #
      #     client.get_source index: 'myindex', type: 'mytype', id: '1'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document; use `_all` to fetch the first document matching the ID across all types (*Required*)
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      #
      # @see http://elasticsearch.org/guide/reference/api/get/
      #
      # @since 0.90.1
      #
      def get_source(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        arguments[:type] ||= UNDERSCORE_ALL
        method = HTTP_GET
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id]),
                                 '_source'

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = nil

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        Utils.__rescue_from_not_found do
          perform_request(method, path, params, body).body
        end
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:get_source, [
          :parent,
          :preference,
          :realtime,
          :refresh,
          :routing,
          :_source,
          :_source_excludes,
          :_source_includes,
          :version,
          :version_type ].freeze)
    end
  end
end
