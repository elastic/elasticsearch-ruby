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
  module XPack
    module API
      module MachineLearning
        module Actions
          # Deletes an existing trained inference model that is currently not referenced by an ingest pipeline.
          # This functionality is Experimental and may be changed or removed
          # completely in a future release. Elastic will take a best effort approach
          # to fix any issues, but experimental features are not subject to the
          # support SLA of official GA features.
          #
          # @option arguments [String] :model_id The ID of the trained model to delete
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/delete-trained-models.html
          #
          def delete_trained_model(arguments = {})
            raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/trained_models/#{Elasticsearch::API::Utils.__listify(_model_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
        end
      end
    end
  end
end
