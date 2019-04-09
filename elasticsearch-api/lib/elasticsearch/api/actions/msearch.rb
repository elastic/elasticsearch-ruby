# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Actions

      # Perform multiple search operations in a single request.
      #
      # Pass the search definitions in the `:body` argument
      #
      # @example Perform multiple different searches as `:search`
      #
      #     client.msearch \
      #       body: [
      #         { search: { query: { match_all: {} } } },
      #         { index: 'myindex', type: 'mytype', search: { query: { query_string: { query: '"Test 1"' } } } },
      #         { search_type: 'count', search: { aggregations: { published: { terms: { field: 'published' } } } } }
      #       ]
      #
      # @example Perform multiple different searches as an array of meta/data pairs
      #
      #     client.msearch \
      #       body: [
      #         { query: { match_all: {} } },
      #         { index: 'myindex', type: 'mytype' },
      #         { query: { query_string: { query: '"Test 1"' } } },
      #         { search_type: 'query_then_fetch' },
      #         { aggregations: { published: { terms: { field: 'published' } } } }
      #       ]
      #
      # @option arguments [List] :index A comma-separated list of index names to use as default
      # @option arguments [List] :type A comma-separated list of document types to use as default
      # @option arguments [Hash] :body The request definitions (metadata-search request definition pairs), separated by newlines (*Required*)
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, query_and_fetch, dfs_query_then_fetch, dfs_query_and_fetch)
      # @option arguments [Number] :max_concurrent_searches Controls the maximum number of concurrent searches the multi search api will execute
      # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
      # @option arguments [Number] :pre_filter_shard_size A threshold that enforces a pre-filter roundtrip to prefilter search shards based on query rewriting if the number of shards the search request expands to exceeds the threshold. This filter roundtrip can limit the number of shards significantly if for instance a shard can not match any documents based on it's rewrite method ie. if date filters are mandatory to match but the shard bounds and the query are disjoint.
      # @option arguments [Number] :max_concurrent_shard_requests The number of concurrent shard requests each sub search executes concurrently. This value should be used to limit the impact of the search on the cluster in order to limit the number of concurrent shard requests
      # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer or an object in the rest search response
      # @option arguments [Boolean] :ccs_minimize_roundtrips Indicates whether network round-trips should be minimized as part of cross-cluster search requests execution
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/5.x/search-multi-search.html
      #
      def msearch(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = HTTP_GET
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_msearch' )

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        case
        when body.is_a?(Array) && body.any? { |d| d.has_key? :search }
          payload = body.
            inject([]) do |sum, item|
              meta = item
              data = meta.delete(:search)

              sum << meta
              sum << data
              sum
            end.
            map { |item| Elasticsearch::API.serializer.dump(item) }
          payload << "" unless payload.empty?
          payload = payload.join("\n")
        when body.is_a?(Array)
          payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
          payload << "" unless payload.empty?
          payload = payload.join("\n")
        else
          payload = body
        end

        perform_request(method, path, params, payload, {"Content-Type" => "application/x-ndjson"}).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:msearch, [
          :search_type,
          :max_concurrent_searches,
          :typed_keys,
          :pre_filter_shard_size,
          :max_concurrent_shard_requests,
          :rest_total_hits_as_int,
          :ccs_minimize_roundtrips ].freeze)
    end
  end
end
