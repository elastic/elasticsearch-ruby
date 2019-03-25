module Elasticsearch
  module API
    module Actions

      # Copy documents from one index to another, potentially changing
      # its settings, mappings and the documents itself.
      #
      # @example Copy documents into a different index
      #
      #     client.reindex body: { source: { index: 'test1' }, dest: { index: 'test2' } }
      #
      # @example Limit the copied documents with a query
      #
      #     client.reindex body: {
      #       source: {
      #         index: 'test1',
      #         query: { terms: { category: ['one', 'two'] }  }
      #       },
      #       dest: {
      #         index: 'test2'
      #       }
      #     }
      #
      # @example Remove a field from reindexed documents
      #
      #     client.reindex body: {
      #       source: {
      #         index: 'test1'
      #       },
      #       dest: {
      #         index: 'test3'
      #       },
      #       script: {
      #         inline: 'ctx._source.remove("category")'
      #       }
      #     }
      #
      # @option arguments [Hash] :body The search definition using the Query DSL and the prototype for the index request. (*Required*)
      # @option arguments [Boolean] :refresh Should the effected indexes be refreshed?
      # @option arguments [Time] :timeout Time each individual bulk request should wait for shards that are unavailable.
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the reindex operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [Boolean] :wait_for_completion Should the request should block until the reindex is complete.
      # @option arguments [Number] :requests_per_second The throttle to set on this request in sub-requests per second. -1 means no throttle.
      # @option arguments [Number] :slices The number of slices this task should be divided into. Defaults to 1 meaning the task isn't sliced into subtasks.
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html
      #
      def reindex(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = 'POST'
        path   = "_reindex"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:reindex, [
          :refresh,
          :timeout,
          :wait_for_active_shards,
          :wait_for_completion,
          :requests_per_second,
          :slices ].freeze)
    end
  end
end
