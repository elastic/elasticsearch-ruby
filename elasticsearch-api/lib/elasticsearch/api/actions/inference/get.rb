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
        # Get an inference endpoint
        #
        # @option arguments [String] :task_type The task type
        # @option arguments [String] :inference_id The inference Id
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-get
        #
        def get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.get' }

          defined_params = [:inference_id, :task_type].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _task_type = arguments.delete(:task_type)

          _inference_id = arguments.delete(:inference_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _task_type && _inference_id
                     "_inference/#{Utils.listify(_task_type)}/#{Utils.listify(_inference_id)}"
                   elsif _inference_id
                     "_inference/#{Utils.listify(_inference_id)}"
                   else
                     '_inference'
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
