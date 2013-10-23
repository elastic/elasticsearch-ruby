module Elasticsearch
  module API
    module Indices
      module Actions

        # Open a previously closed index (see the {Indices::Actions#close} API).
        #
        # @example Open index named _myindex_
        #
        #     client.indices.open index: 'myindex'
        #
        # @option arguments [String] :index The name of the index (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-open-close/
        #
        def open(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          valid_params = [ :timeout ]

          method = 'POST'
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_open'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
