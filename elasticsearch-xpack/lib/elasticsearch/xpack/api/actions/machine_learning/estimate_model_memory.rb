# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # TODO: Description

          # @option arguments [Hash] :body The analysis config, plus cardinality estimates for fields it references (*Required*)
          #
          # @see [TODO]
          #
          def estimate_model_memory(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/_estimate_model_memory"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
