# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Creates an inference trained model.
          #
          # @option arguments [String] :model_id The ID of the trained models to store
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The trained model configuration (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/put-inference.html
          #
          def put_trained_model(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_ml/inference/#{Elasticsearch::API::Utils.__listify(_model_id)}"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
