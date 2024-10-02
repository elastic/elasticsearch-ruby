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
    module AsyncSearch
      module Actions
        # Executes a search request asynchronously.
        #
        # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Time] :wait_for_completion_timeout Specify the time that the request should block waiting for the final response
        # @option arguments [Boolean] :keep_on_completion Control whether the response should be stored in the cluster if it completed within the provided [wait_for_completion] time (default: false)
        # @option arguments [Time] :keep_alive Update the time interval in which the results (partial or final) for this search will be available
        # @option arguments [Number] :batched_reduce_size The number of shard results that should be reduced at once on the coordinating node. This value should be used as the granularity at which progress results will be made available.
        # @option arguments [Boolean] :request_cache Specify if request cache should be used for this request or not, defaults to true
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
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [Boolean] :lenient Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
        # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
        # @option arguments [String] :q Query in the Lucene query string syntax
        # @option arguments [List] :routing A comma-separated list of specific routing values
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
        # @option arguments [Boolean|long] :track_total_hits Indicate if the number of documents that match the query should be tracked. A number can also be specified, to accurately track the total hit count up to the number.
        # @option arguments [Boolean] :allow_partial_search_results Indicate if an error should be returned if there is a partial search failure or timeout
        # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
        # @option arguments [Boolean] :version Specify whether to return document version as part of a hit
        # @option arguments [Boolean] :seq_no_primary_term Specify whether to return sequence number and primary term of the last modification of each hit
        # @option arguments [Number] :max_concurrent_shard_requests The number of concurrent shard requests per node this search executes concurrently. This value should be used to limit the impact of the search on the cluster in order to limit the number of concurrent shard requests
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The search definition using the Query DSL
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/async-search.html
        #
        def submit(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'async_search.submit' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "#{Utils.__listify(_index)}/_async_search"
                   else
                     '_async_search'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
