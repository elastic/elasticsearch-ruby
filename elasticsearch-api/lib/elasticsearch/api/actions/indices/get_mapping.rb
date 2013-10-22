module Elasticsearch
  module API
    module Indices
      module Actions

        # Return the mapping definitions for all indices, or specific indices/types.
        #
        # @example Get all mappings in the cluster
        #
        #     client.indices.get_mapping
        #
        # @example Get mapping for a specific index
        #
        #     client.indices.get_mapping index: 'foo'
        #
        # @example Get mapping for a specific type in a specific index
        #
        #     client.indices.get_mapping index: 'foo', type: 'baz'
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string for all indices
        # @option arguments [List] :type A comma-separated list of document types
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-get-mapping/
        #
        def get_mapping(arguments={})
          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_mapping'
          params = {}
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
