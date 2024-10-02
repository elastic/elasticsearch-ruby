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
        # Returns data streams.
        #
        # @option arguments [List] :name A comma-separated list of data streams to get; use `*` to get all data streams
        # @option arguments [String] :expand_wildcards Whether wildcard expressions should get expanded to open or closed indices (default: open) (options: open, closed, hidden, none, all)
        # @option arguments [Boolean] :include_defaults Return all relevant default configurations for the data stream (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :verbose Whether the maximum timestamp for each data stream should be calculated and returned (default: false)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/data-streams.html
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
                     "_data_stream/#{Utils.__listify(_name)}"
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
