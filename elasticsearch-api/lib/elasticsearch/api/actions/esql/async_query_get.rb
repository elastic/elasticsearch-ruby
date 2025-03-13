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
        # Get async ES|QL query results.
        # Get the current status and available results or stored results for an ES|QL asynchronous query.
        # If the Elasticsearch security features are enabled, only the user who first submitted the ES|QL query can retrieve the results using this API.
        #
        # @option arguments [String] :id The unique identifier of the query.
        #  A query ID is provided in the ES|QL async query API response for a query that does not complete in the designated time.
        #  A query ID is also provided when the request was submitted with the +keep_on_completion+ parameter set to +true+. (*Required*)
        # @option arguments [Boolean] :drop_null_columns Indicates whether columns that are entirely +null+ will be removed from the +columns+ and +values+ portion of the results.
        #  If +true+, the response will include an extra section under the name +all_columns+ which has the name of all the columns.
        # @option arguments [Time] :keep_alive The period for which the query and its results are stored in the cluster.
        #  When this period expires, the query and its results are deleted, even if the query is still ongoing.
        # @option arguments [Time] :wait_for_completion_timeout The period to wait for the request to finish.
        #  By default, the request waits for complete query results.
        #  If the request completes during the period specified in this parameter, complete query results are returned.
        #  Otherwise, the response returns an +is_running+ value of +true+ and no results.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-esql-async-query-get
        #
        def async_query_get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'esql.async_query_get' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_query/async/#{Utils.listify(_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
