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
    module Inference
      module Actions
        # Update an inference endpoint.
        # Modify +task_settings+, secrets (within +service_settings+), or +num_allocations+ for an inference endpoint, depending on the specific endpoint service and +task_type+.
        # IMPORTANT: The inference APIs enable you to use certain services, such as built-in machine learning models (ELSER, E5), models uploaded through Eland, Cohere, OpenAI, Azure, Google AI Studio, Google Vertex AI, Anthropic, Watsonx.ai, or Hugging Face.
        # For built-in models and models uploaded through Eland, the inference APIs offer an alternative way to use and manage trained models.
        # However, if you do not plan to use the inference APIs to use these models or if you want to use non-NLP models, use the machine learning trained model APIs.
        #
        # @option arguments [String] :inference_id The unique identifier of the inference endpoint. (*Required*)
        # @option arguments [String] :task_type The type of inference task that the model performs.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body inference_config
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-update
        #
        def update(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.update' }

          defined_params = [:inference_id, :task_type].inject({}) do |set_variables, variable|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
            set_variables
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'inference_id' missing" unless arguments[:inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _inference_id = arguments.delete(:inference_id)

          _task_type = arguments.delete(:task_type)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _task_type && _inference_id
                     "_inference/#{Utils.__listify(_task_type)}/#{Utils.__listify(_inference_id)}/_update"
                   else
                     "_inference/#{Utils.__listify(_inference_id)}/_update"
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
