module Elasticsearch
  module API
    module Indices
      module Actions

        # Create or update an index warmer.
        #
        # An index warmer will run before an index is refreshed, ie. available for search.
        # It allows you to register "heavy" queries with popular filters, facets or sorts,
        # increasing performance when the index is searched for the first time.
        #
        # @example Register a warmer which will populate the caches for `published` filter and sorting on `created_at`
        #
        #     client.indices.put_warmer index: 'myindex',
        #                               name: 'main',
        #                               body: {
        #                                 query: { filtered: { filter: { term: { published: true } } } },
        #                                 sort:  [ "created_at" ]
        #                               }
        #
        # @option arguments [List] :index A comma-separated list of index names to register the warmer for; use `_all`
        #                                 or empty string to perform the operation on all indices (*Required*)
        # @option arguments [String] :name The name of the warmer (*Required*)
        # @option arguments [List] :type A comma-separated list of document types to register the warmer for;
        #                                leave empty to perform the operation on all types
        # @option arguments [Hash] :body The search request definition for the warmer
        #                                (query, filters, facets, sorting, etc) (*Required*)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-warmers/
        #
        def put_warmer(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = 'PUT'
          path   = Utils.__pathify( Utils.__listify(arguments[:index]),
                                    Utils.__listify(arguments[:type]),
                                    '_warmer',
                                    Utils.__listify(arguments[:name]) )
          params = {}
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
