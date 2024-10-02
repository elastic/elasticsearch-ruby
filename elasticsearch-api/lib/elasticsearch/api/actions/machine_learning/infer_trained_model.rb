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
    module MachineLearning
      module Actions
        # Evaluate a trained model.
        #
        # @option arguments [String] :model_id The unique identifier of the trained model. (*Required*)
        # @option arguments [Time] :timeout Controls the amount of time to wait for inference results.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The docs to apply inference on and inference configuration overrides (*Required*)
        #
        # *Deprecation notice*:
        # /_ml/trained_models/{model_id}/deployment/_infer is deprecated. Use /_ml/trained_models/{model_id}/_infer instead
        # Deprecated since version 8.3.0
        #
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/infer-trained-model.html
        #
        def infer_trained_model(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.infer_trained_model' }

          defined_params = [:model_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _model_id = arguments.delete(:model_id)

          method = Elasticsearch::API::HTTP_POST
          path   = ("_ml/trained_models/#{Utils.__listify(_model_id)}/deployment/_infer" if _model_id)
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
