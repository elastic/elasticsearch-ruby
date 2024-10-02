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
    module Eql
      module Actions
        # Returns results matching a query expressed in Event Query Language (EQL)
        #
        # @option arguments [String] :index The name of the index to scope the operation
        # @option arguments [Time] :wait_for_completion_timeout Specify the time that the request should block waiting for the final response
        # @option arguments [Boolean] :keep_on_completion Control whether the response should be stored in the cluster if it completed within the provided [wait_for_completion] time (default: false)
        # @option arguments [Time] :keep_alive Update the time interval in which the results (partial or final) for this search will be available
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Eql request body. Use the `query` to limit the query scope. (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/eql-search-api.html
        #
        def search(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'eql.search' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.__listify(_index)}/_eql/search"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
