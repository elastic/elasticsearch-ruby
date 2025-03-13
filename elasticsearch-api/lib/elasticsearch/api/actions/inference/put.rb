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
        # Create an inference endpoint.
        # When you create an inference endpoint, the associated machine learning model is automatically deployed if it is not already running.
        # After creating the endpoint, wait for the model deployment to complete before using it.
        # To verify the deployment status, use the get trained model statistics API.
        # Look for +"state": "fully_allocated"+ in the response and ensure that the +"allocation_count"+ matches the +"target_allocation_count"+.
        # Avoid creating multiple endpoints for the same model unless required, as each endpoint consumes significant resources.
        # IMPORTANT: The inference APIs enable you to use certain services, such as built-in machine learning models (ELSER, E5), models uploaded through Eland, Cohere, OpenAI, Mistral, Azure OpenAI, Google AI Studio, Google Vertex AI, Anthropic, Watsonx.ai, or Hugging Face.
        # For built-in models and models uploaded through Eland, the inference APIs offer an alternative way to use and manage trained models.
        # However, if you do not plan to use the inference APIs to use these models or if you want to use non-NLP models, use the machine learning trained model APIs.
        #
        # @option arguments [String] :task_type The task type
        # @option arguments [String] :inference_id The inference Id (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body inference_config
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-put
        #
        def put(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.put' }

          defined_params = [:inference_id, :task_type].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'inference_id' missing" unless arguments[:inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _task_type = arguments.delete(:task_type)

          _inference_id = arguments.delete(:inference_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _task_type && _inference_id
                     "_inference/#{Utils.listify(_task_type)}/#{Utils.listify(_inference_id)}"
                   else
                     "_inference/#{Utils.listify(_inference_id)}"
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
