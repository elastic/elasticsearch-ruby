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
    module Inference
      module Actions
        # Configure an inference endpoint for use in the Inference API
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :inference_id The inference Id
        # @option arguments [String] :task_type The task type
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The inference endpoint's task and service settings
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/put-inference-api.html
        #
        def put(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.put' }

          defined_params = %i[inference_id task_type].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'inference_id' missing" unless arguments[:inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _inference_id = arguments.delete(:inference_id)

          _task_type = arguments.delete(:task_type)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _task_type && _inference_id
                     "_inference/#{Utils.__listify(_task_type)}/#{Utils.__listify(_inference_id)}"
                   else
                     "_inference/#{Utils.__listify(_inference_id)}"
                   end
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
