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
    module Indices
      module Actions

        # Validate a query
        #
        # @example Validate a simple query string query
        #
        #     client.indices.validate_query index: 'myindex', q: 'title:foo AND body:bar'
        #
        # @example Validate an invalid query (with explanation)
        #
        #     client.indices.validate_query index: 'myindex', q: '[[[ BOOM! ]]]', explain: true
        #
        # @example Validate a DSL query (with explanation and rewrite). With rewrite set to true, the 
        #                                explanation is more detailed showing the actual Lucene query that will 
        #                                be executed.
        #
        #     client.indices.validate_query index: 'myindex',
        #                                   rewrite: true,
        #                                   explain: true,
        #                                   body: {
        #                                     filtered: {
        #                                       query: {
        #                                         match: {
        #                                           title: 'foo'
        #                                         }
        #                                       },
        #                                       filter: {
        #                                         range: {
        #                                           published_at: {
        #                                             from: '2013-06-01'
        #                                           }
        #                                         }
        #                                       }
        #                                     }
        #                                   }
        #
        # @option arguments [List] :index A comma-separated list of index names to restrict the operation; use `_all` or empty string to perform the operation on all indices
        # @option arguments [List] :type A comma-separated list of document types to restrict the operation; leave empty to perform the operation on all types
        # @option arguments [Hash] :body The query definition specified with the Query DSL
        # @option arguments [Boolean] :explain Return detailed information about the error
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [String] :q Query in the Lucene query string syntax
        # @option arguments [String] :analyzer The analyzer to use for the query string
        # @option arguments [Boolean] :analyze_wildcard Specify whether wildcard and prefix queries should be analyzed (default: false)
        # @option arguments [String] :default_operator The default operator for query string query (AND or OR) (options: AND, OR)
        # @option arguments [String] :df The field to use as default where no field prefix is given in the query string
        # @option arguments [Boolean] :lenient Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
        # @option arguments [Boolean] :rewrite Provide a more detailed explanation showing the actual Lucene query that will be executed.
        # @option arguments [Boolean] :all_shards Execute validation on all shards instead of one random shard per index
        #
        # @see https://www.elastic.co/guide/reference/api/validate/
        #
        def validate_query(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]),
                                   Utils.__listify(arguments[:type]),
                                   '_validate/query'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:validate_query, [
            :explain,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :q,
            :analyzer,
            :analyze_wildcard,
            :default_operator,
            :df,
            :lenient,
            :rewrite,
            :all_shards ].freeze)
      end
    end
  end
end
