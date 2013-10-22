module Elasticsearch
  module API
    module Indices
      module Actions

        # Get one or more warmers for an index.
        #
        # @example Get all warmers
        #
        #     client.indices.get_warmer index: '_all'
        #
        # @example Get all warmers matching a wildcard expression
        #
        #     client.indices.get_warmer index: '_all', name: 'ba*'
        #
        # @example Get all warmers for a single index
        #
        #     client.indices.get_warmer index: 'foo'
        #
        # @example Get a specific warmer
        #
        #     client.indices.get_warmer index: 'foo', name: 'bar'
        #
        # @option arguments [List] :index A comma-separated list of index names to restrict the operation;
        #                                 use `_all` to perform the operation on all indices (*Required*)
        # @option arguments [String] :name The name of the warmer (supports wildcards); leave empty to get all warmers
        # @option arguments [List] :type A comma-separated list of document types to restrict the operation;
        #                                leave empty to perform the operation on all types
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-warmers/
        #
        def get_warmer(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = 'GET'
          path   = Utils.__pathify( Utils.__listify(arguments[:index]), '_warmer', Utils.__escape(arguments[:name]) )
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
