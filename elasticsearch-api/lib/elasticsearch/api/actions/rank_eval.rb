# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Actions
      # Allows to evaluate the quality of ranked search results over a set of typical search queries
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, dfs_query_then_fetch)
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The ranking evaluation search definition, including search requests, document ratings and ranking metric definition. (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/search-rank-eval.html
      #
      def rank_eval(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'rank_eval' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body   = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = if _index
                   "#{Utils.__listify(_index)}/_rank_eval"
                 else
                   '_rank_eval'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
