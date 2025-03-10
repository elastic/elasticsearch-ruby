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
        # Create a Watsonx inference endpoint.
        # Creates an inference endpoint to perform an inference task with the +watsonxai+ service.
        # You need an IBM Cloud Databases for Elasticsearch deployment to use the +watsonxai+ inference service.
        # You can provision one through the IBM catalog, the Cloud Databases CLI plug-in, the Cloud Databases API, or Terraform.
        # When you create an inference endpoint, the associated machine learning model is automatically deployed if it is not already running.
        # After creating the endpoint, wait for the model deployment to complete before using it.
        # To verify the deployment status, use the get trained model statistics API.
        # Look for +"state": "fully_allocated"+ in the response and ensure that the +"allocation_count"+ matches the +"target_allocation_count"+.
        # Avoid creating multiple endpoints for the same model unless required, as each endpoint consumes significant resources.
        #
        # @option arguments [String] :task_type The task type.
        #  The only valid task type for the model to perform is +text_embedding+. (*Required*)
        # @option arguments [String] :watsonx_inference_id The unique identifier of the inference endpoint. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/infer-service-watsonx-ai.html
        #
        def put_watsonx(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.put_watsonx' }

          defined_params = [:task_type, :watsonx_inference_id].inject({}) do |set_variables, variable|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
            set_variables
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'task_type' missing" unless arguments[:task_type]

          raise ArgumentError,
                "Required argument 'watsonx_inference_id' missing" unless arguments[:watsonx_inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _task_type = arguments.delete(:task_type)

          _watsonx_inference_id = arguments.delete(:watsonx_inference_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_inference/#{Utils.__listify(_task_type)}/#{Utils.__listify(_watsonx_inference_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
