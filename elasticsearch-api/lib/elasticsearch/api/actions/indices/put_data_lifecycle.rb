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
        # Update data stream lifecycles.
        # Update the data stream lifecycle of the specified data streams.
        #
        # @option arguments [String, Array<String>] :name Comma-separated list of data streams used to limit the request.
        #  Supports wildcards (+*+).
        #  To target all data streams use +*+ or +_all+. (*Required*)
        # @option arguments [String, Array<String>] :expand_wildcards Type of data stream that wildcard patterns can match.
        #  Supports comma-separated values, such as +open,hidden+.
        #  Valid values are: +all+, +hidden+, +open+, +closed+, +none+. Server default: open.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is
        #  received before the timeout expires, the request fails and returns an
        #  error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-data-lifecycle
        #
        def put_data_lifecycle(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.put_data_lifecycle' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_data_stream/#{Utils.listify(_name)}/_lifecycle"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
