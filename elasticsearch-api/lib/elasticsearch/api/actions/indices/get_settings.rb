module Elasticsearch
  module API
    module Indices
      module Actions

        # Return the settings for all indices, or a list of indices.
        #
        # @example Get settings for all indices
        #
        #     client.indices.get_settings
        #
        # @example Get settings for an index named _myindex_
        #
        #     client.indices.get_settings index: 'myindex'
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                 to perform the operation on all indices
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-get-settings/
        #
        def get_settings(arguments={})
          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_settings'
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
