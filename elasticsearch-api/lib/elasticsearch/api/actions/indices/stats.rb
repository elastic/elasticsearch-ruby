module Elasticsearch
  module API
    module Indices
      module Actions

        # Return statistical information about one or more indices.
        #
        # The response contains comprehensive statistical information about metrics related to index:
        # how much time did indexing, search and other operations take, how much disk space it takes,
        # how much memory filter caches or field data require, etc.
        #
        # @example Get default statistics for all indices
        #
        #     client.indices.stats
        #
        # @example Get all available statistics for a single index
        #
        #     client.indices.stats index: 'foo', all: true
        #
        # @example Get statistics about documents and disk size for multiple indices
        #
        #     client.indices.stats index: ['foo', 'bar'], clear: true, docs: true, store: true
        #
        # @example Get statistics about filter cache and field data, for all indices
        #
        #     client.indices.stats clear: true, fielddata: true , filter_cache: true, fields: '*'
        #
        # @example Get statistics about searches, with segmentation for different search groups
        #
        #     client.indices.stats clear: true, search: true , groups: ['groupA', 'groupB']
        #
        # @since The `fielddata`, `filter_cache` and `id_cache` metrics are available from version 0.90.
        #
        # @option arguments [List] :search_groups A comma-separated list of search groups to include
        #                                         in the `search` statistics
        # @option arguments [Boolean] :all Return all available information
        # @option arguments [Boolean] :clear Reset the default level of detail
        # @option arguments [Boolean] :docs Return information about indexed and deleted documents
        # @option arguments [Boolean] :fielddata Return information about field data
        # @option arguments [Boolean] :fields A comma-separated list of fields for `fielddata` metric (supports wildcards)
        # @option arguments [Boolean] :filter_cache Return information about filter cache
        # @option arguments [Boolean] :flush Return information about flush operations
        # @option arguments [Boolean] :get Return information about get operations
        # @option arguments [Boolean] :groups A comma-separated list of search groups for `search` statistics
        # @option arguments [Boolean] :id_cache Return information about ID cache
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                 to perform the operation on all indices
        # @option arguments [Boolean] :indexing Return information about indexing operations
        # @option arguments [List] :indexing_types A comma-separated list of document types to include
        #                                          in the `indexing` statistics
        # @option arguments [Boolean] :merge Return information about merge operations
        # @option arguments [Boolean] :refresh Return information about refresh operations
        # @option arguments [Boolean] :search Return information about search operations; use the `groups` parameter to
        #                                     include information for specific search groups
        # @option arguments [Boolean] :store Return information about the size of the index
        # @option arguments [Boolean] :warmer Return information about warmers
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-indices-stats/
        #
        def stats(arguments={})
          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_stats'
          params = arguments.select do |k,v|
            [ :all,
              :clear,
              :docs,
              :fielddata,
              :fields,
              :filter_cache,
              :flush,
              :get,
              :groups,
              :id_cache,
              :ignore_indices,
              :indexing,
              :merge,
              :refresh,
              :search,
              :store,
              :warmer ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body   = nil

          params[:fields] = Utils.__listify(params[:fields]) if params[:fields]
          params[:groups] = Utils.__listify(params[:groups]) if params[:groups]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
