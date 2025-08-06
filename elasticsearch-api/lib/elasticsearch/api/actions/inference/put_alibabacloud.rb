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
        # Configure an AlibabaCloud AI Search inference endpoint
        #
        # @option arguments [String] :task_type The task type
        # @option arguments [String] :alibabacloud_inference_id The inference Id
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The inference endpoint's task and service settings
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/infer-service-alibabacloud-ai-search.html
        #
        def put_alibabacloud(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.put_alibabacloud' }

          defined_params = %i[task_type alibabacloud_inference_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'task_type' missing" unless arguments[:task_type]

          unless arguments[:alibabacloud_inference_id]
            raise ArgumentError,
                  "Required argument 'alibabacloud_inference_id' missing"
          end

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _task_type = arguments.delete(:task_type)

          _alibabacloud_inference_id = arguments.delete(:alibabacloud_inference_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_inference/#{Utils.__listify(_task_type)}/#{Utils.__listify(_alibabacloud_inference_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
