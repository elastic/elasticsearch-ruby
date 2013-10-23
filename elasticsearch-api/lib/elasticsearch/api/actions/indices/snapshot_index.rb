module Elasticsearch
  module API
    module Indices
      module Actions

        # When using the shared storage gateway, manually trigger the snapshot operation.
        #
        # @deprecated The shared gateway has been deprecated [https://github.com/elasticsearch/elasticsearch/issues/2458]
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                to perform the operation on all indices
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-gateway-snapshot/
        #
        def snapshot_index(arguments={})
          valid_params = [ :ignore_indices ]

          method = 'POST'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_gateway/snapshot'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
