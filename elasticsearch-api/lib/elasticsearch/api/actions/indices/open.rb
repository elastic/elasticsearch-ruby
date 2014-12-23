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
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-open-close/
        #
        def open(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          valid_params = [
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :timeout
          ]

          method = HTTP_POST
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_open'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
