module Elasticsearch
  module API
    module Actions

      # Return names of queries matching the passed document.
      #
      # Percolator allows you to register queries and then evaluate a document against them:
      # the IDs of matching queries are returned in the response.
      #
      # @example Register queries named "alert-1" and "alert-2" for the "myindex" index
      #
      #     client.index index: '_percolator',
      #                  type: 'myindex',
      #                  id: 'alert-1',
      #                  body: { query: { query_string: { query: 'foo' } } }
      #
      #     client.index index: '_percolator',
      #                  type: 'myindex',
      #                  id: 'alert-2',
      #                  body: { query: { query_string: { query: 'bar' } } }
      #
      # @example Evaluate a document against the queries
      #
      #     client.percolate index: 'myindex', body: { doc: { title: "Foo" } }
      #     # => {"ok":true,"matches":["alert-1"]}
      #
      #     client.percolate index: 'myindex', body: { doc: { title: "Foo Bar" } }
      #     # => {"ok":true,"matches":["alert-1","alert-2"]}
      #
      # @option arguments [String] :index The name of the index with a registered percolator query (*Required*)
      # @option arguments [String] :type The document type
      # @option arguments [Hash] :body The document (`doc`) to percolate against registered queries;
      #                                optionally also a `query` to limit the percolation to specific registered queries
      # @option arguments [Boolean] :prefer_local With `true`, specify that a local shard should be used if available,
      #                                           with `false`, use a random shard (default: true)
      #
      # @see http://elasticsearch.org/guide/reference/api/percolate/
      #
      def percolate(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'body' missing"  unless arguments[:body]
        arguments[:type] ||= 'document'

        valid_params = [ :prefer_local ]

        method = 'GET'
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 '_percolate'

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
