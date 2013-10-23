module Elasticsearch
  module API
    module Indices
      module Actions

        # Get a list of all aliases, or aliases for a specific index.
        #
        # @example Get a list of all aliases
        #
        #     client.indices.get_aliases
        #
        # @option arguments [List] :index A comma-separated list of index names to filter aliases
        # @option arguments [Time] :timeout Explicit timestamp for the document
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def get_aliases(arguments={})
          valid_params = [ :timeout ]

          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_aliases'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
