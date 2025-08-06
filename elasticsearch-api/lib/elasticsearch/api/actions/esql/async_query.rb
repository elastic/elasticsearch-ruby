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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Esql
      module Actions
        # Run an async ES|QL query.
        # Asynchronously run an ES|QL (Elasticsearch query language) query, monitor its progress, and retrieve results when they become available.
        # The API accepts the same parameters and request body as the synchronous query API, along with additional async related properties.
        #
        # @option arguments [Boolean] :allow_partial_results If `true`, partial results will be returned if there are shard failures, but the query can continue to execute on other clusters and shards.
        #  If `false`, the query will fail if there are any failures.To override the default behavior, you can set the `esql.query.allow_partial_results` cluster setting to `false`. Server default: true.
        # @option arguments [String] :delimiter The character to use between values within a CSV row.
        #  It is valid only for the CSV format.
        # @option arguments [Boolean] :drop_null_columns Indicates whether columns that are entirely `null` will be removed from the `columns` and `values` portion of the results.
        #  If `true`, the response will include an extra section under the name `all_columns` which has the name of all the columns.
        # @option arguments [String] :format A short version of the Accept header, e.g. json, yaml.`csv`, `tsv`, and `txt` formats will return results in a tabular format, excluding other metadata fields from the response.For async requests, nothing will be returned if the async query doesn't finish within the timeout.
        #  The query ID and running status are available in the `X-Elasticsearch-Async-Id` and `X-Elasticsearch-Async-Is-Running` HTTP headers of the response, respectively.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-esql-async-query
        #
        def async_query(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'esql.async_query' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_query/async'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
