module Elasticsearch
  module API
    module Actions

      # Perform multiple index, delete or update operations in a single request.
      #
      # Pass the operations in the `:body` option as an array of hashes, following Elasticsearch conventions.
      # For operations which take data, pass them as the `:data` option in the operation hash.
      #
      # @example Perform three operations in a single request, passing actions and data as an array of hashes
      #
      #     client.bulk body: [
      #       { index: { _index: 'myindex', _type: 'mytype', _id: 1 } },
      #       { title: 'foo' },
      #
      #       { index: { _index: 'myindex', _type: 'mytype', _id: 2 } },
      #       { title: 'foo' },
      #
      #       { delete: { _index: 'myindex', _type: 'mytype', _id: 3  } }
      #     ]
      # @example Perform three operations in a single request, passing data in the `:data` option
      #
      #     client.bulk body: [
      #       { index:  { _index: 'myindex', _type: 'mytype', _id: 1, data: { title: 'foo' } } },
      #       { update: { _index: 'myindex', _type: 'mytype', _id: 2, data: { doc: { title: 'foo' } } } },
      #       { delete: { _index: 'myindex', _type: 'mytype', _id: 3  } }
      #     ]
      #
      # @example Perform a script-based bulk update, passing scripts in the `:data` option
      #
      #     client.bulk body: [
      #       { update: { _index: 'myindex', _type: 'mytype', _id: 1,
      #                  data: {
      #                   script: "ctx._source.counter += value",
      #                   lang: 'js',
      #                   params: { value: 1 }, upsert: { counter: 0 } }
      #                 }},
      #       { update: { _index: 'myindex', _type: 'mytype', _id: 2,
      #                  data: {
      #                   script: "ctx._source.counter += value",
      #                   lang: 'js',
      #                   params: { value: 42 }, upsert: { counter: 0 } }
      #                  }}
      #
      #     ]
      #
      # @option arguments [String]      :index Default index for items which don't provide one
      # @option arguments [String]      :type Default document type for items which don't provide one
      # @option arguments [Array<Hash>] :body An array of operations to perform, each operation is a Hash
      # @option arguments [String]  :consistency Explicit write consistency setting for the operation
      #                             (options: one, quorum, all)
      # @option arguments [Boolean] :refresh Refresh the index after performing the operation
      # @option arguments [String]  :replication Explicitly set the replication type (options: sync, async)
      # @option arguments [Time]    :timeout Explicit operation timeout
      # @option arguments [String]  :fields Default comma-separated list of fields to return
      #                             in the response for updates
      #
      # @return [Hash] Deserialized Elasticsearch response
      #
      # @see http://elasticsearch.org/guide/reference/api/bulk/
      #
      def bulk(arguments={})
        arguments = arguments.clone

        type      = arguments.delete(:type)

        valid_params = [
          :consistency,
          :refresh,
          :replication,
          :type,
          :timeout,
          :fields ]

        method = HTTP_POST
        path   = Utils.__pathify Utils.__escape(arguments[:index]), Utils.__escape(type), '_bulk'

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        if body.is_a? Array
          payload = Utils.__bulkify(body)
        else
          payload = body
        end

        perform_request(method, path, params, payload).body
      end
    end
  end
end
