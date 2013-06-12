module Elasticsearch
  module API
    module Actions

      # Perform multiple index, delete or update operations in a single request.
      #
      # Pass the operations in the `:body` option as an array of hashes, following Elasticsearch conventions.
      # For operations which take data, pass them as the `:data` option in the operation hash.
      #
      # @example Perform three operations in a single request
      #
      #     client.bulk body: [
      #       {index:  { _index: 'myindex', _type: 'mytype', _id: 1, data: { title: 'foo' } }},
      #       {update: { _index: 'myindex', _type: 'mytype', _id: 2, data: { doc: { title: 'foo' } } }},
      #       {delete: { _index: 'myindex', _type: 'mytype', _id: 3 },
      #     ]
      #
      # @example Performing a script-based batch updates
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
      # @option arguments [String] :index Default index for items which don't provide one
      # @option arguments [String] :type Default document type for items which don't provide one
      # @option arguments [Array<Hash>] :body An array of operations to perform, each operation is a Hash
      # @option arguments [String] :consistency Explicit write consistency setting for the operation (options: one, quorum, all)
      # @option arguments [Boolean] :refresh Refresh the index after performing the operation
      # @option arguments [String] :replication Explicitely set the replication type (options: sync, async)
      # @option arguments [String] :type Default document type for items which don't provide one
      #
      # @return [Hash] Deserialized Elasticsearch response
      #
      # @see http://elasticsearch.org/guide/reference/api/bulk/
      #
      def bulk(arguments={})
        method = 'POST'
        path   = [arguments[:index], arguments[:type], '_bulk'].compact.join('/')
        params = arguments.select do |k,v|
          [ :consistency,
            :refresh,
            :replication,
            :type ].include?(k)
        end
        # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        params = Hash[params] unless params.is_a?(Hash)
        body   = arguments[:body]

        if body.is_a? Array
          payload = body.
            inject([]) do |sum, item|
              operation, meta = item.to_a.first
              data            = meta.delete(:data)

              sum << { operation => meta }
              sum << data if data
              sum
            end.
            map { |item| MultiJson.dump(item) }
          payload << "" unless payload.empty?
          payload = payload.join("\n")
        else
          payload = body
        end

        perform_request(method, path, params, payload).body
      end
    end
  end
end
