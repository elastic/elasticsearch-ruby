module Elasticsearch
  module API
    module Actions

      # Delete a single document.
      #
      # @example Delete a document
      #
      #     client.delete index: 'myindex', type: 'mytype', id: '1'
      #
      # @example Delete a document with specific routing
      #
      #     client.delete index: 'myindex', type: 'mytype', id: '1', routing: 'abc123'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before
      #   proceeding with the delete operation. Defaults to 1, meaning the primary shard only. Set to `all` for all
      #   shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for
      #   the shard (number of replicas + 1)
      # @option arguments [String] :parent ID of parent document
      # @option arguments [String] :refresh If `true` then refresh the effected shards to make this operation visible
      #   to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false`
      #   (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :if_seq_no only perform the delete operation if the last operation that has changed
      #   the document has the specified sequence number
      # @option arguments [Number] :if_primary_term only perform the delete operation if the last operation that has
      #   changed the document has the specified primary term
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type
      #   (options: internal, external, external_gte, force)
      #
      # @see http://elasticsearch.org/guide/reference/api/delete/
      #
      def delete(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]

        method = HTTP_DELETE
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id])

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = nil

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        else
          perform_request(method, path, params, body).body
        end
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:delete, [
          :wait_for_active_shards,
          :parent,
          :refresh,
          :routing,
          :timeout,
          :if_seq_no,
          :if_primary_term,
          :version,
          :version_type ].freeze)
    end
  end
end
