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

      # Configure the search definition witha template in Mustache and parameters
      #
      # @example Insert the start and end values for the `range` query
      #
      #     client.search_template index: 'myindex',
      #                            body: {
      #                              template: {
      #                                query: {
      #                                  range: {
      #                                    date: { gte: "{{start}}", lte: "{{end}}" }
      #                                  }
      #                                }
      #                              },
      #                              params: { start: "2014-02-01", end: "2014-03-01" }
      #                            }
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [List] :type A comma-separated list of document types to search; leave empty to perform the operation on all types
      # @option arguments [Hash] :body The search definition template and its params (*Required*)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :ignore_throttled Whether specified concrete, expanded or aliased indices should be ignored when throttled
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [List] :routing A comma-separated list of specific routing values
      # @option arguments [Time] :scroll Specify how long a consistent view of the index should be maintained for scrolled search
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, query_and_fetch, dfs_query_then_fetch, dfs_query_and_fetch)
      # @option arguments [Boolean] :explain Specify whether to return detailed information about score computation as part of a hit
      # @option arguments [Boolean] :profile Specify whether to profile the query execution
      # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
      # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer or an object in the rest search response
      # @option arguments [Boolean] :ccs_minimize_roundtrips Indicates whether network round-trips should be minimized as part of cross-cluster search requests execution
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-template.html
      #
      def search_template(arguments={})
        method = HTTP_GET
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_search/template' )
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:search_template, [
          :ignore_unavailable,
          :ignore_throttled,
          :allow_no_indices,
          :expand_wildcards,
          :preference,
          :routing,
          :scroll,
          :search_type,
          :explain,
          :profile,
          :typed_keys,
          :rest_total_hits_as_int,
          :ccs_minimize_roundtrips ].freeze)
    end
  end
end
