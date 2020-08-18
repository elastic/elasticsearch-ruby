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

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Starts one or more datafeeds.
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to start
          # @option arguments [String] :start The start time from where the datafeed should begin
          # @option arguments [String] :end The end time when the datafeed should stop. When not set, the datafeed continues in real time
          # @option arguments [Time] :timeout Controls the time to wait until a datafeed has started. Default to 20 seconds
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The start datafeed parameters
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.9/ml-start-datafeed.html
          #
          def start_datafeed(arguments = {})
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _datafeed_id = arguments.delete(:datafeed_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/datafeeds/#{Elasticsearch::API::Utils.__listify(_datafeed_id)}/_start"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:start_datafeed, [
            :start,
            :end,
            :timeout
          ].freeze)
        end
      end
    end
  end
end
