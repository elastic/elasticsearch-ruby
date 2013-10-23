module Elasticsearch
  module API
    module Indices
      module Actions

        # Validate a query
        #
        # @example Validate a simple query string query
        #
        #     client.indices.validate_query index: 'myindex', q: 'title:foo AND body:bar'
        #
        # @example Validate an invalid query (with explanation)
        #
        #     client.indices.validate_query index: 'myindex', q: '[[[ BOOM! ]]]', explain: true
        #
        # @example Validate a DSL query (with explanation)
        #
        #     client.indices.validate_query index: 'myindex',
        #                                   explain: true,
        #                                   body: {
        #                                     filtered: {
        #                                       query: {
        #                                         match: {
        #                                           title: 'foo'
        #                                         }
        #                                       },
        #                                       filter: {
        #                                         range: {
        #                                           published_at: {
        #                                             from: '2013-06-01'
        #                                           }
        #                                         }
        #                                       }
        #                                     }
        #                                   }
        #
        # @option arguments [List] :index A comma-separated list of index names to restrict the operation;
        #                                 use `_all` or empty string to perform the operation on all indices
        # @option arguments [List] :type A comma-separated list of document types to restrict the operation;
        #                                leave empty to perform the operation on all types
        # @option arguments [Hash] :body The query definition (*without* the top-level `query` element)
        # @option arguments [Boolean] :explain Return detailed information about the error
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        # @option arguments [String] :source The URL-encoded query definition (instead of using the request body)
        # @option arguments [String] :q Query in the Lucene query string syntax
        #
        # @see http://www.elasticsearch.org/guide/reference/api/validate/
        #
        def validate_query(arguments={})
          valid_params = [
            :q,
            :explain,
            :ignore_indices,
            :source ]

          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]),
                                   Utils.__listify(arguments[:type]),
                                   '_validate/query'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
