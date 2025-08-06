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
        # Updates a data stream's settings
        #
        # @option arguments [String] :name Comma-separated list of data streams or data stream patterns
        # @option arguments [Boolean] :dry_run Whether this request should only be a dry run rather than actually applying settings
        # @option arguments [Time] :timeout Period to wait for a response
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The data stream settings to be updated (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/data-streams.html
        #
        def put_data_stream_settings(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.put_data_stream_settings' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_data_stream/#{Utils.__listify(_name)}/_settings"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
