module Elasticsearch
  module API
    module Actions

      # Return documents matching a query, as well as aggregations (facets), highlighted snippets, suggestions, etc.
      #
      # The search API is used to query one or more indices either using simple
      # [query string queries](http://www.elasticsearch.org/guide/reference/api/search/uri-request/)
      # as the `:q` argument , or by passing the
      # [full request definition](http://www.elasticsearch.org/guide/reference/api/search/request-body/)
      # in the [Query DSL](http://www.elasticsearch.org/guide/reference/query-dsl/) as the `:body` argument.
      #
      # @example Search with a simple query string query
      #
      #     client.search index: 'myindex', q: 'title:test'
      #
      # @example Passing a full request definition in the Elasticsearch's Query DSL as a `Hash`
      #
      #     client.search index: 'myindex',
      #                   body: {
      #                     query: { match: { title: 'test' } },
      #                     aggregations: { tags: { terms: { field: 'tags' } } }
      #                   }
      #
      # @example Paginating results: return 10 documents, beginning from the 10th
      #
      #     client.search index: 'myindex',
      #                   body: {
      #                     query: { match: { title: 'test' } },
      #                     from: 10,
      #                     size: 10
      #                   }
      #
      # @example Passing the search definition as a `String`, built with a JSON builder
      #
      #     require 'jbuilder'
      #
      #     json = Jbuilder.encode do |json|
      #       json.query do
      #         json.match do
      #           json.title do
      #             json.query    'test 1'
      #             json.operator 'and'
      #           end
      #         end
      #       end
      #     end
      #
      #     client.search index: 'myindex', body: json
      #
      # @example Wrapping the result in [`Hashie::Mash`](https://github.com/intridea/hashie) for easier access
      #
      #     response = client.search index: 'myindex',
      #                              body: {
      #                                query:  { match: { title: 'test' } },
      #                                aggregations: { tags:  { terms: { field: 'tags' } } }
      #                              }
      #
      #     response = Hashie::Mash.new response
      #
      #     response.hits.hits.first._source.title
      #
      #     response.aggregations.tags.terms.to_a.map { |f| "#{f.term} [#{f.count}]" }.join(', ')
      #
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [List] :type A comma-separated list of document types to search; leave empty to perform the operation on all types
      # @option arguments [Hash] :body The search definition using the Query DSL
      # @option arguments [String] :analyzer The analyzer to use for the query string
      # @option arguments [Boolean] :analyze_wildcard Specify whether wildcard and prefix queries should be analyzed (default: false)
      # @option arguments [String] :default_operator The default operator for query string query (AND or OR) (options: AND, OR)
      # @option arguments [String] :df The field to use as default where no field prefix is given in the query string
      # @option arguments [Boolean] :explain Specify whether to return detailed information about score computation as part of a hit
      # @option arguments [List] :stored_fields A comma-separated list of stored fields to return as part of a hit
      # @option arguments [List] :docvalue_fields A comma-separated list of fields to return as the docvalue representation of a field for each hit
      # @option arguments [Number] :from Starting offset (default: 0)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :ignore_throttled Whether specified concrete, expanded or aliased indices should be ignored when throttled
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
      # @option arguments [Boolean] :lenient Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [String] :q Query in the Lucene query string syntax
      # @option arguments [List] :routing A comma-separated list of specific routing values
      # @option arguments [Time] :scroll Specify how long a consistent view of the index should be maintained for scrolled search
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, dfs_query_then_fetch)
      # @option arguments [Number] :size Number of hits to return (default: 10)
      # @option arguments [List] :sort A comma-separated list of <field>:<direction> pairs
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      # @option arguments [Number] :terminate_after The maximum number of documents to collect for each shard, upon reaching which the query execution will terminate early.
      # @option arguments [List] :stats Specific 'tag' of the request for logging and statistical purposes
      # @option arguments [String] :suggest_field Specify which field to use for suggestions
      # @option arguments [String] :suggest_mode Specify suggest mode (options: missing, popular, always)
      # @option arguments [Number] :suggest_size How many suggestions to return in response
      # @option arguments [String] :suggest_text The source text for which the suggestions should be returned
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Boolean] :track_scores Whether to calculate and return scores even if they are not used for sorting
      # @option arguments [Boolean] :track_total_hits Indicate if the number of documents that match the query should be tracked
      # @option arguments [Boolean] :allow_partial_search_results Indicate if an error should be returned if there is a partial search failure or timeout
      # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
      # @option arguments [Boolean] :version Specify whether to return document version as part of a hit
      # @option arguments [Boolean] :request_cache Specify if request cache should be used for this request or not, defaults to index level setting
      # @option arguments [Number] :batched_reduce_size The number of shard results that should be reduced at once on the coordinating node. This value should be used as a protection mechanism to reduce the memory overhead per search request if the potential number of shards in the request can be large.
      # @option arguments [Number] :max_concurrent_shard_requests The number of concurrent shard requests this search executes concurrently. This value should be used to limit the impact of the search on the cluster in order to limit the number of concurrent shard requests
      # @option arguments [Number] :pre_filter_shard_size A threshold that enforces a pre-filter roundtrip to prefilter search shards based on query rewriting if the number of shards the search request expands to exceeds the threshold. This filter roundtrip can limit the number of shards significantly if for instance a shard can not match any documents based on it's rewrite method ie. if date filters are mandatory to match but the shard bounds and the query are disjoint.
      # @option arguments [Boolean] :rest_total_hits_as_int This parameter is ignored in this version. It is used in the next major version to control whether the rest response should render the total.hits as an object or a number
      #
      # @return [Hash]
      #
      # @see http://www.elasticsearch.org/guide/reference/api/search/
      # @see http://www.elasticsearch.org/guide/reference/api/search/request-body/
      #
      def search(arguments={})
        arguments[:index] = UNDERSCORE_ALL if ! arguments[:index] && arguments[:type]
        method = HTTP_GET
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), UNDERSCORE_SEARCH )

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body   = arguments[:body]

        params[:fields] = Utils.__listify(params[:fields], :escape => false) if params[:fields]
        params[:fielddata_fields] = Utils.__listify(params[:fielddata_fields], :escape => false) if params[:fielddata_fields]

        # FIX: Unescape the `filter_path` parameter due to __listify default behavior. Investigate.
        params[:filter_path] =  defined?(EscapeUtils) ? EscapeUtils.unescape_url(params[:filter_path]) : CGI.unescape(params[:filter_path]) if params[:filter_path]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:search, [
          :analyzer,
          :analyze_wildcard,
          :default_operator,
          :df,
          :explain,
          :stored_fields,
          :docvalue_fields,
          :from,
          :ignore_unavailable,
          :ignore_throttled,
          :allow_no_indices,
          :expand_wildcards,
          :lenient,
          :preference,
          :q,
          :routing,
          :scroll,
          :search_type,
          :size,
          :sort,
          :_source,
          :_source_excludes,
          :_source_includes,
          :terminate_after,
          :stats,
          :suggest_field,
          :suggest_mode,
          :suggest_size,
          :suggest_text,
          :timeout,
          :track_scores,
          :track_total_hits,
          :allow_partial_search_results,
          :typed_keys,
          :version,
          :request_cache,
          :batched_reduce_size,
          :max_concurrent_shard_requests,
          :pre_filter_shard_size,
          :rest_total_hits_as_int,
          :seq_no_primary_term ].freeze)
    end
  end
end
