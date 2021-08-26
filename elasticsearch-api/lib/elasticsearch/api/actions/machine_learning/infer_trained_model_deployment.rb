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

module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Evaluate a trained model.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :model_id The unique identifier of the trained model. (*Required*)
        # @option arguments [Time] :timeout Controls the amount of time to wait for inference results.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The docs to apply inference on (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/infer-trained-model-deployment.html
        #
        def infer_trained_model_deployment(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _model_id = arguments.delete(:model_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/trained_models/#{Utils.__listify(_model_id)}/deployment/_infer"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:infer_trained_model_deployment, [
          :timeout
        ].freeze)
      end
    end
  end
end
