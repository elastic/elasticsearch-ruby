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
        # @example Get all available statistics for all indices
        #
        #     client.indices.stats
        #
        # @example Get statistics for a single index
        #
        #     client.indices.stats index: 'foo'
        #
        # @example Get statistics about documents and disk size for multiple indices
        #
        #     client.indices.stats index: ['foo', 'bar'], docs: true, store: true
        #
        # @example Get statistics about filter cache and field data for all fields
        #
        #     client.indices.stats fielddata: true, filter_cache: true
        #
        # @example Get statistics about filter cache and field data for specific fields
        #
        #     client.indices.stats fielddata: true, filter_cache: true, fields: 'created_at,tags'
        #
        # @example Get statistics about filter cache and field data per field for all fields
        #
        #     client.indices.stats fielddata: true, filter_cache: true, fields: '*'
        #
        # @example Get statistics about searches, with segmentation for different search groups
        #
        #     client.indices.stats search: true, groups: ['groupA', 'groupB']
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [List] :metric Limit the information returned the specific metrics. (options: _all,completion,docs,fielddata,query_cache,flush,get,indexing,merge,request_cache,refresh,search,segments,store,warmer,suggest)
        # @option arguments [List] :completion_fields A comma-separated list of fields for `fielddata` and `suggest` index metric (supports wildcards)
        # @option arguments [List] :fielddata_fields A comma-separated list of fields for `fielddata` index metric (supports wildcards)
        # @option arguments [List] :fields A comma-separated list of fields for `fielddata` and `completion` index metric (supports wildcards)
        # @option arguments [List] :groups A comma-separated list of search groups for `search` index metric
        # @option arguments [String] :level Return stats aggregated at cluster, index or shard level (options: cluster, indices, shards)
        # @option arguments [List] :types A comma-separated list of document types for the `indexing` index metric
        # @option arguments [Boolean] :include_segment_file_sizes Whether to report the aggregated disk usage of each one of the Lucene index files (only applies if segment stats are requested)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-stats.html
        #
        def stats(arguments={})
          method = Elasticsearch::API::HTTP_GET
          path   = "_stats"
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:stats, [
            :completion_fields,
            :fielddata_fields,
            :fields,
            :groups,
            :level,
            :types,
            :include_segment_file_sizes ].freeze)
      end
    end
  end
end

