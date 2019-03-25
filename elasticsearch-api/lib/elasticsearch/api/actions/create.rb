module Elasticsearch
  module API
    module Actions

      # Create a new document.
      #
      # The index API adds or updates a JSON document in a specific index, making it searchable.
      #
      # @option arguments [String] :id Document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [Hash] :body The document (*Required*)
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active
      #   before proceeding with the index operation. Defaults to 1, meaning the primary shard only. Set to `all` for
      #   all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies
      #   for the shard (number of replicas + 1)
      # @option arguments [String] :parent ID of the parent document
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible
      #   to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false`
      #   (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      # @option arguments [String] :pipeline The pipeline id to preprocess incoming documents with
      #
      # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/docs-index_.html
      #
      def create(arguments={})
        if arguments[:id]
          index arguments.update :op_type => 'create'
        else
          index arguments
        end
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:create, [
          :wait_for_active_shards,
          :parent,
          :refresh,
          :routing,
          :timeout,
          :version,
          :version_type,
          :pipeline ].freeze)
    end
  end
end
