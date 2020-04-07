# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Deletes an existing trained inference model that is currently not referenced by an ingest pipeline.
          #
          # @option arguments [String] :model_id The ID of the trained model to delete
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/delete-inference.html
          #
          def delete_trained_model(arguments = {})
            raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/inference/#{Elasticsearch::API::Utils.__listify(_model_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
