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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Inference
      module Actions
        # Create a Hugging Face inference endpoint.
        # Create an inference endpoint to perform an inference task with the +hugging_face+ service.
        # You must first create an inference endpoint on the Hugging Face endpoint page to get an endpoint URL.
        # Select the model you want to use on the new endpoint creation page (for example +intfloat/e5-small-v2+), then select the sentence embeddings task under the advanced configuration section.
        # Create the endpoint and copy the URL after the endpoint initialization has been finished.
        # The following models are recommended for the Hugging Face service:
        # * +all-MiniLM-L6-v2+
        # * +all-MiniLM-L12-v2+
        # * +all-mpnet-base-v2+
        # * +e5-base-v2+
        # * +e5-small-v2+
        # * +multilingual-e5-base+
        # * +multilingual-e5-small+
        # When you create an inference endpoint, the associated machine learning model is automatically deployed if it is not already running.
        # After creating the endpoint, wait for the model deployment to complete before using it.
        # To verify the deployment status, use the get trained model statistics API.
        # Look for +"state": "fully_allocated"+ in the response and ensure that the +"allocation_count"+ matches the +"target_allocation_count"+.
        # Avoid creating multiple endpoints for the same model unless required, as each endpoint consumes significant resources.
        #
        # @option arguments [String] :task_type The type of the inference task that the model will perform. (*Required*)
        # @option arguments [String] :huggingface_inference_id The unique identifier of the inference endpoint. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-put-hugging-face
        #
        def put_hugging_face(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.put_hugging_face' }

          defined_params = [:task_type, :huggingface_inference_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'task_type' missing" unless arguments[:task_type]

          unless arguments[:huggingface_inference_id]
            raise ArgumentError,
                  "Required argument 'huggingface_inference_id' missing"
          end

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _task_type = arguments.delete(:task_type)

          _huggingface_inference_id = arguments.delete(:huggingface_inference_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_inference/#{Utils.listify(_task_type)}/#{Utils.listify(_huggingface_inference_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
