module Elasticsearch
  module API
    module Actions

      # Create or update a document.
      #
      # The `index` API will either _create_ a new document, or _update_ an existing one, when a document `:id`
      # is passed. When creating a document, an ID will be auto-generated, when it's not passed as an argument.
      #
      # You can specifically enforce the _create_ operation by setting the `op_type` argument to `create`, or
      # by using the {Actions#create} method.
      #
      # Optimistic concurrency control is performed, when the `version` argument is specified. By default,
      # no version checks are performed.
      #
      # By default, the document will be available for {Actions#get} immediately, for {Actions#search} only
      # after an index refresh operation has been performed (either automatically or manually).
      #
      # @example Create or update a document `myindex/mytype/1`
      #
      #     client.index index: 'myindex',
      #                  type: 'mytype',
      #                  id: '1',
      #                  body: {
      #                   title: 'Test 1',
      #                   tags: ['y', 'z'],
      #                   published: true,
      #                   published_at: Time.now.utc.iso8601,
      #                   counter: 1
      #                 }
      #
      # @example Refresh the index after the operation (useful e.g. in integration tests)
      #
      #     client.index index: 'myindex', type: 'mytype', id: '1', body: { title: 'TEST' }, refresh: true
      #     client.search index: 'myindex', q: 'title:test'
      #
      # @example Create a document with a specific expiration time (TTL)
      #
      #     # Decrease the default housekeeping interval first:
      #     client.cluster.put_settings body: { transient: { 'indices.ttl.interval' => '1s' } }
      #
      #     # Enable the `_ttl` property for all types within the index
      #     client.indices.create index: 'myindex', body: { mappings: { mytype: { _ttl: { enabled: true } }  } }
      #
      #     client.index index: 'myindex', type: 'mytype', id: '1', body: { title: 'TEST' }, ttl: '5s'
      #
      #     sleep 3 and client.get index: 'myindex', type: 'mytype', id: '1'
      #     # => {"_index"=>"myindex" ... "_source"=>{"title"=>"TEST"}}
      #
      #     sleep 3 and client.get index: 'myindex', type: 'mytype', id: '1'
      #     # => Elasticsearch::Transport::Transport::Errors::NotFound: [404] ...
      #
      # @option arguments [String] :id Document ID
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [Hash] :body The document (*Required*)
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the index operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [String] :op_type Explicit operation type (options: index, create)
      # @option arguments [String] :parent ID of the parent document
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      # @option arguments [Number] :if_seq_no only perform the index operation if the last operation that has changed the document has the specified sequence number
      # @option arguments [Number] :if_primary_term only perform the index operation if the last operation that has changed the document has the specified primary term
      # @option arguments [String] :pipeline The pipeline id to preprocess incoming documents with
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html
      #
      def index(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        method = arguments[:id] ? HTTP_PUT : HTTP_POST
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id])

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:index, [
          :wait_for_active_shards,
          :op_type,
          :parent,
          :refresh,
          :routing,
          :timeout,
          :version,
          :version_type,
          :if_seq_no,
          :if_primary_term,
          :pipeline ].freeze)
    end
  end
end
