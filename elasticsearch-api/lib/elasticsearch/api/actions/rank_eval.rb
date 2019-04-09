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

      # The ranking evaluation API allows to evaluate the quality of ranked search results over a set of typical search queries.
      #   Given this set of queries and a list of manually rated documents, the _rank_eval endpoint calculates and
      #   returns typical information retrieval metrics like mean reciprocal rank, precision or discounted cumulative gain.
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [Hash] :body The ranking evaluation search definition, including search requests, document ratings and ranking metric definition. (*Required*)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-rank-eval.html
      #
      def rank_eval(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = Elasticsearch::API::HTTP_GET
        path   = "_rank_eval"
        params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:rank_eval, [
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards ].freeze)
    end
  end
end
