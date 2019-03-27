module Elasticsearch
  module API
    module Actions

      # Update a document without sending the whole document in the request ("partial update").
      #
      # Send either a partial document (`doc` ) which will be deeply merged into an existing document,
      # or a `script`, which will update the document content, in the `:body` argument.
      #
      # The partial update operation allows you to limit the amount of data you send over the wire and
      # reduces the chance of failed updates due to conflict.
      #
      # Specify the `:version` and `:retry_on_conflict` arguments to balance convenience and consistency.
      #
      # @example Update document _title_ using partial `doc`-ument
      #
      #     client.update index: 'myindex', type: 'mytype', id: '1',
      #                   body: { doc: { title: 'Updated' } }
      #
      # @example Add a tag to document `tags` property using a `script`
      #
      #     client.update index: 'myindex', type: 'mytype', id: '1',
      #                    body: { script: { source: 'ctx._source.tags.add(params.tag)', params: { tag: 'x' } } }
      #
      # @example Increment a document counter by 1 _or_ initialize it, when the document does not exist
      #
      #     client.update index: 'myindex', type: 'mytype', id: '666',
      #                   body: { script: 'ctx._source.counter += 1', upsert: { counter: 1 } }
      #
      # @example Delete a document if it's tagged "to-delete"
      #
      #     client.update index: 'myindex', type: 'mytype', id: '1',
      #                   body: { script: 'ctx._source.tags.contains(params.tag) ? ctx.op = "delete" : ctx.op = "none"',
      #                           params: { tag: 'to-delete' } }
      #
      #
      # @option arguments [String] :id Document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [Hash] :body The request definition requires either `script` or partial `doc` (*Required*)
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the update operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      # @option arguments [String] :lang The script language (default: painless)
      # @option arguments [String] :parent ID of the parent document. Is is only used for routing and when for the upsert request
      # @option arguments [String] :refresh If `true` then refresh the effected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [Number] :retry_on_conflict Specify how many times should the operation be retried when a conflict occurs (default: 0)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, force)
      # @since 0.20
      #
      # @see http://elasticsearch.org/guide/reference/api/update/
      #
      def update(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        method = HTTP_POST
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id]),
                                 '_update'

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        else
          perform_request(method, path, params, body).body
        end
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:update, [
          :wait_for_active_shards,
          :fields,
          :_source,
          :_source_excludes,
          :_source_includes,
          :lang,
          :parent,
          :refresh,
          :retry_on_conflict,
          :routing,
          :timeout,
          :version,
          :version_type,
          :if_seq_no,
          :include_type_name,
          :if_primary_term ].freeze)
    end
  end
end
