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
      # @option arguments [Hash] :body The definition of the operation (source index, target index, ...)
      #                                (*Required*)
      # @option arguments [Boolean] :refresh Whether the affected indexes should be refreshed
      # @option arguments [Time] :timeout Time each individual bulk request should wait for shards
      #                                   that are unavailable. (Default: 1m)
      # @option arguments [String] :consistency Explicit write consistency setting for the operation
      #                                        (Options: one, quorum, all)
      # @option arguments [Boolean] :wait_for_completion Whether the request should block and wait until
        #                                                the operation has completed
      # @option arguments [Float] :requests_per_second The throttling for this request in sub-requests per second.
      #                                                0 means set no throttling (default)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html
      #
      def reindex(arguments={})
        Utils.__report_unsupported_method(__method__)

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        valid_params = [
          :refresh,
          :timeout,
          :consistency,
          :wait_for_completion,
          :requests_per_second ]

        method = HTTP_POST
        path   = "_reindex"
        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
