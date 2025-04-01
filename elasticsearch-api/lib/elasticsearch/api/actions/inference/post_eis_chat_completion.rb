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
        # Perform a chat completion task through the Elastic Inference Service (EIS).
        # Perform a chat completion inference task with the +elastic+ service.
        #
        # @option arguments [String] :eis_inference_id The unique identifier of the inference endpoint. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body chat_completion_request
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-post-eis-chat-completion
        #
        def post_eis_chat_completion(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.post_eis_chat_completion' }

          defined_params = [:eis_inference_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'eis_inference_id' missing" unless arguments[:eis_inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _eis_inference_id = arguments.delete(:eis_inference_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_inference/chat_completion/#{Utils.listify(_eis_inference_id)}/_stream"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
