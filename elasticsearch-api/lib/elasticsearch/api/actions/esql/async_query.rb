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
    module Esql
      module Actions
        # Run an async ES|QL query.
        # Asynchronously run an ES|QL (Elasticsearch query language) query, monitor its progress, and retrieve results when they become available.
        # The API accepts the same parameters and request body as the synchronous query API, along with additional async related properties.
        #
        # @option arguments [String] :delimiter The character to use between values within a CSV row.
        #  It is valid only for the CSV format.
        # @option arguments [Boolean] :drop_null_columns Indicates whether columns that are entirely +null+ will be removed from the +columns+ and +values+ portion of the results.
        #  If +true+, the response will include an extra section under the name +all_columns+ which has the name of all the columns.
        # @option arguments [String] :format A short version of the Accept header, for example +json+ or +yaml+.
        # @option arguments [Time] :keep_alive The period for which the query and its results are stored in the cluster.
        #  The default period is five days.
        #  When this period expires, the query and its results are deleted, even if the query is still ongoing.
        #  If the +keep_on_completion+ parameter is false, Elasticsearch only stores async queries that do not complete within the period set by the +wait_for_completion_timeout+ parameter, regardless of this value. Server default: 5d.
        # @option arguments [Boolean] :keep_on_completion Indicates whether the query and its results are stored in the cluster.
        #  If false, the query and its results are stored in the cluster only if the request does not complete during the period set by the +wait_for_completion_timeout+ parameter.
        # @option arguments [Time] :wait_for_completion_timeout The period to wait for the request to finish.
        #  By default, the request waits for 1 second for the query results.
        #  If the query completes during this period, results are returned
        #  Otherwise, a query ID is returned that can later be used to retrieve the results. Server default: 1s.
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
