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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Validate a query.
        # Validates a query without running it.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases to search.
        #  Supports wildcards (+*+).
        #  To search all data streams or indices, omit this parameter or use +*+ or +_all+.
        # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices. Server default: true.
        # @option arguments [Boolean] :all_shards If +true+, the validation is executed on all shards instead of one random shard per index.
        # @option arguments [String] :analyzer Analyzer to use for the query string.
        #  This parameter can only be used when the +q+ query string parameter is specified.
        # @option arguments [Boolean] :analyze_wildcard If +true+, wildcard and prefix queries are analyzed.
        # @option arguments [String] :default_operator The default operator for query string query: +AND+ or +OR+. Server default: OR.
        # @option arguments [String] :df Field to use as default where no field prefix is given in the query string.
        #  This parameter can only be used when the +q+ query string parameter is specified.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as +open,hidden+.
        #  Valid values are: +all+, +open+, +closed+, +hidden+, +none+. Server default: open.
        # @option arguments [Boolean] :explain If +true+, the response returns detailed information if an error has occurred.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
        # @option arguments [Boolean] :lenient If +true+, format-based query failures (such as providing text to a numeric field) in the query string will be ignored.
        # @option arguments [Boolean] :rewrite If +true+, returns a more detailed explanation showing the actual Lucene query that will be executed.
        # @option arguments [String] :q Query in the Lucene query string syntax.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-validate-query
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

          path   = if _index
                     "#{Utils.listify(_index)}/_validate/query"
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
