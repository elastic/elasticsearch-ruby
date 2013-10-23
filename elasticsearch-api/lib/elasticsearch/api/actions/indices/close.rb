module Elasticsearch
  module API
    module Indices
      module Actions

        # Close an index (keep the data on disk, but deny operations with the index).
        #
        # A closed index can be opened again with the {Indices::Actions#close} API.
        #
        # @example Close index named _myindex_
        #
        #     client.indices.close index: 'myindex'
        #
        # @option arguments [String] :index The name of the index (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-open-close/
        #
        def close(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          valid_params = [ :timeout ]

          method = 'POST'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_close'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
