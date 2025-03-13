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
    module Fleet
      module Actions
        # Get global checkpoints.
        # Get the current global checkpoints for an index.
        # This API is designed for internal use by the Fleet server project.
        #
        # @option arguments [Indexname, Indexalias] :index A single index or index alias that resolves to a single index. (*Required*)
        # @option arguments [Boolean] :wait_for_advance A boolean value which controls whether to wait (until the timeout) for the global checkpoints
        #  to advance past the provided +checkpoints+.
        # @option arguments [Boolean] :wait_for_index A boolean value which controls whether to wait (until the timeout) for the target index to exist
        #  and all primary shards be active. Can only be true when +wait_for_advance+ is true.
        # @option arguments [Array<Integer>] :checkpoints A comma separated list of previous global checkpoints. When used in combination with +wait_for_advance+,
        #  the API will only return once the global checkpoints advances past the checkpoints. Providing an empty list
        #  will cause Elasticsearch to immediately return the current global checkpoints. Server default: [].
        # @option arguments [Time] :timeout Period to wait for a global checkpoints to advance past +checkpoints+. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-fleet
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

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = "#{Utils.listify(_index)}/_fleet/global_checkpoints"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
