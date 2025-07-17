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
        # Create an inference endpoint.
        # IMPORTANT: The inference APIs enable you to use certain services, such as built-in machine learning models (ELSER, E5), models uploaded through Eland, Cohere, OpenAI, Mistral, Azure OpenAI, Google AI Studio, Google Vertex AI, Anthropic, Watsonx.ai, or Hugging Face.
        # For built-in models and models uploaded through Eland, the inference APIs offer an alternative way to use and manage trained models.
        # However, if you do not plan to use the inference APIs to use these models or if you want to use non-NLP models, use the machine learning trained model APIs.
        # The following integrations are available through the inference API. You can find the available task types next to the integration name:
        # * AlibabaCloud AI Search (`completion`, `rerank`, `sparse_embedding`, `text_embedding`)
        # * Amazon Bedrock (`completion`, `text_embedding`)
        # * Anthropic (`completion`)
        # * Azure AI Studio (`completion`, `text_embedding`)
        # * Azure OpenAI (`completion`, `text_embedding`)
        # * Cohere (`completion`, `rerank`, `text_embedding`)
        # * Elasticsearch (`rerank`, `sparse_embedding`, `text_embedding` - this service is for built-in models and models uploaded through Eland)
        # * ELSER (`sparse_embedding`)
        # * Google AI Studio (`completion`, `text_embedding`)
        # * Google Vertex AI (`rerank`, `text_embedding`)
        # * Hugging Face (`chat_completion`, `completion`, `rerank`, `text_embedding`)
        # * Mistral (`chat_completion`, `completion`, `text_embedding`)
        # * OpenAI (`chat_completion`, `completion`, `text_embedding`)
        # * VoyageAI (`text_embedding`, `rerank`)
        # * Watsonx inference integration (`text_embedding`)
        # * JinaAI (`text_embedding`, `rerank`)
        #
        # @option arguments [String] :task_type The task type. Refer to the integration list in the API description for the available task types.
        # @option arguments [String] :inference_id The inference Id (*Required*)
        # @option arguments [Time] :timeout Specifies the amount of time to wait for the inference endpoint to be created. Server default: 30s.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
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
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
