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
    module Fleet
      module Actions
        # Returns the current global checkpoints for an index. This API is design for internal use by the fleet server project.
        #
        # @option arguments [String] :index The name of the index.
        # @option arguments [Boolean] :wait_for_advance Whether to wait for the global checkpoint to advance past the specified current checkpoints
        # @option arguments [Boolean] :wait_for_index Whether to wait for the target index to exist and all primary shards be active
        # @option arguments [List] :checkpoints Comma separated list of checkpoints
        # @option arguments [Time] :timeout Timeout to wait for global checkpoint to advance
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/get-global-checkpoints.html
        #
        def global_checkpoints(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'fleet.global_checkpoints' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = "#{Utils.__listify(_index)}/_fleet/global_checkpoints"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
