module Elasticsearch
  module API
    module Indices
      module Actions

        # Clear caches and other auxiliary data structures.
        #
        # Can be performed against a specific index, or against all indices.
        #
        # By default, all caches and data structures will be cleared.
        # Pass a specific cache or structure name to clear just a single one.
        #
        # @example Clear all caches and data structures
        #
        #     client.indices.clear_cache
        #
        # @example Clear the field data structure only
        #
        #     client.indices.clear_cache field_data: true
        #
        # @example Clear only specific field in the field data structure
        #
        #     client.indices.clear_cache field_data: true, fields: 'created_at', filter_cache: false, id_cache: false
        #
        # @option arguments [List] :index A comma-separated list of index name to limit the operation
        # @option arguments [Boolean] :field_data Clear field data
        # @option arguments [Boolean] :fielddata Clear field data
        # @option arguments [List] :fields A comma-separated list of fields to clear when using the
        #                                  `field_data` parameter(default: all)
        # @option arguments [Boolean] :filter Clear filter caches
        # @option arguments [Boolean] :filter_cache Clear filter caches
        # @option arguments [Boolean] :filter_keys A comma-separated list of keys to clear when using the
        #                                          `filter_cache` parameter (default: all)
        # @option arguments [Boolean] :id Clear ID caches for parent/child
        # @option arguments [Boolean] :id_cache Clear ID caches for parent/child
        # @option arguments [String] :ignore_indices When performed on multiple indices,
        #                                            allows to ignore `missing` ones (options: none, missing)
        # @option arguments [List] :index A comma-separated list of index name to limit the operation
        # @option arguments [Boolean] :recycler Clear the recycler cache
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-clearcache/
        #
        def clear_cache(arguments={})
          valid_params = [
            :field_data,
            :fielddata,
            :fields,
            :filter,
            :filter_cache,
            :filter_keys,
            :id,
            :id_cache,
            :ignore_indices,
            :recycler ]

          method = 'POST'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_cache/clear'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
