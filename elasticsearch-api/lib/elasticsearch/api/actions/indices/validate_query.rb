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
    module Indices
      module Actions
        # Allows a user to validate a potentially expensive query without executing it.
        #
        # @option arguments [List] :index A comma-separated list of index names to restrict the operation; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Boolean] :explain Return detailed information about the error
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [String] :q Query in the Lucene query string syntax
        # @option arguments [String] :analyzer The analyzer to use for the query string
        # @option arguments [Boolean] :analyze_wildcard Specify whether wildcard and prefix queries should be analyzed (default: false)
        # @option arguments [String] :default_operator The default operator for query string query (AND or OR) (options: AND, OR)
        # @option arguments [String] :df The field to use as default where no field prefix is given in the query string
        # @option arguments [Boolean] :lenient Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
        # @option arguments [Boolean] :rewrite Provide a more detailed explanation showing the actual Lucene query that will be executed.
        # @option arguments [Boolean] :all_shards Execute validation on all shards instead of one random shard per index
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The query definition specified with the Query DSL
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/search-validate.html
        #
        def validate_query(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.validate_query' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path = if _index
                   "#{Utils.__listify(_index)}/_validate/query"
                 else
                   '_validate/query'
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
