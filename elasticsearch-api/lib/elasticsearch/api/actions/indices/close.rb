module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_CLOSE_PARAMS = [
          :ignore_indices,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :timeout
        ].freeze

        # Close an index (keep the data on disk, but deny operations with the index).
        #
        # A closed index can be opened again with the {Indices::Actions#close} API.
        #
        # @example Close index named _myindex_
        #
        #     client.indices.close index: 'myindex'
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
        def close(arguments={})
          close_request_for(arguments).body
        end

        def close_request_for(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_close'

          params = Utils.__validate_and_extract_params arguments, VALID_CLOSE_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
