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
    module SQL
      module Actions
        # Get async SQL search results.
        # Get the current status and available results for an async SQL search or stored synchronous SQL search.
        # If the Elasticsearch security features are enabled, only the user who first submitted the SQL search can retrieve the search using this API.
        #
        # @option arguments [String] :id The identifier for the search. (*Required*)
        # @option arguments [String] :delimiter The separator for CSV results.
        #  The API supports this parameter only for CSV responses. Server default: ,.
        # @option arguments [String] :format The format for the response.
        #  You must specify a format using this parameter or the +Accept+ HTTP header.
        #  If you specify both, the API uses this parameter.
        # @option arguments [Time] :keep_alive The retention period for the search and its results.
        #  It defaults to the +keep_alive+ period for the original SQL search.
        # @option arguments [Time] :wait_for_completion_timeout The period to wait for complete results.
        #  It defaults to no timeout, meaning the request waits for complete search results.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-sql-get-async
        #
        def get_async(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'sql.get_async' }

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
          path   = "_sql/async/#{Utils.listify(_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
