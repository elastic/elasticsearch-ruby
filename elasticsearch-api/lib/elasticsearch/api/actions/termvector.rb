module Elasticsearch
  module API
    module Actions

      # Return information and statistics about terms in the fields of a particular document
      #
      # @example Get statistics for a specific document
      #
      #     client.indices.create index: 'my_index',
      #                           body: {
      #                             mappings: {
      #                               my_type: {
      #                                 properties: {
      #                                   text: {
      #                                     type: 'string',
      #                                     term_vector: 'with_positions_offsets_payloads'
      #                                   }
      #                                 }
      #                               }
      #                             }
      #                           }
      #
      #     client.index index: 'my_index', type: 'my_type', id: '1', body: { text: 'Foo Bar Fox' }
      #
      #     client.termvector index: 'my_index', type: 'my_type', id: '1'
      #     # => { ..., "term_vectors" => { "text" => { "field_statistics" => { ... }, "terms" => { "bar" => ... } } }
      #
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [Hash] :body The request definition
      # @option arguments [Boolean] :term_statistics Whether total term frequency and
      #                                              document frequency should be returned
      # @option arguments [Boolean] :field_statistics Whether document count, sum of document frequencies
      #                                               and sum of total term frequencies should be returned
      # @option arguments [List] :fields A comma-separated list of fields to return
      # @option arguments [Boolean] :offsets Whether term offsets should be returned
      # @option arguments [Boolean] :positions Whether term positions should be returned
      # @option arguments [Boolean] :payloads Whether term payloads should be returned
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :parent Parent ID of the documents
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/docs-termvectors.html
      #
      def termvector(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing" unless arguments[:type]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        valid_params = [
          :term_statistics,
          :field_statistics,
          :fields,
          :offsets,
          :positions,
          :payloads,
          :preference,
          :routing,
          :parent ]

        method = 'GET'

        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 arguments[:id],
                                 '_termvector'

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
