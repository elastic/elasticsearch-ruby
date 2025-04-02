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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Get data streams.
        # Get information about one or more data streams.
        #
        # @option arguments [String, Array<String>] :name Comma-separated list of data stream names used to limit the request.
        #  Wildcard (+*+) expressions are supported. If omitted, all data streams are returned.
        # @option arguments [String, Array<String>] :expand_wildcards Type of data stream that wildcard patterns can match.
        #  Supports comma-separated values, such as +open,hidden+. Server default: open.
        # @option arguments [Boolean] :include_defaults If true, returns all relevant default configurations for the index template.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Boolean] :verbose Whether the maximum timestamp for each data stream should be calculated and returned.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-get-data-stream
        #
        def get_data_stream(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.get_data_stream' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_GET
          path   = if _name
                     "_data_stream/#{Utils.listify(_name)}"
                   else
                     '_data_stream'
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
