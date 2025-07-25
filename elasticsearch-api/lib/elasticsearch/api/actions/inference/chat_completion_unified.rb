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
        # Perform chat completion inference
        # The chat completion inference API enables real-time responses for chat completion tasks by delivering answers incrementally, reducing response times during computation.
        # It only works with the `chat_completion` task type for `openai` and `elastic` inference services.
        # NOTE: The `chat_completion` task type is only available within the _stream API and only supports streaming.
        # The Chat completion inference API and the Stream inference API differ in their response structure and capabilities.
        # The Chat completion inference API provides more comprehensive customization options through more fields and function calling support.
        # If you use the `openai`, `hugging_face` or the `elastic` service, use the Chat completion inference API.
        #
        # @option arguments [String] :inference_id The inference Id (*Required*)
        # @option arguments [Time] :timeout Specifies the amount of time to wait for the inference request to complete. Server default: 30s.
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
        # @option arguments [Hash] :body chat_completion_request
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-unified-inference
        #
        def chat_completion_unified(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.chat_completion_unified' }

          defined_params = [:inference_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'inference_id' missing" unless arguments[:inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _inference_id = arguments.delete(:inference_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_inference/chat_completion/#{Utils.listify(_inference_id)}/_stream"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
