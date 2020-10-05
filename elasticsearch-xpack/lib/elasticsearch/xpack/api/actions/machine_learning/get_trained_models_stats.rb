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
          # Retrieves usage information for trained inference models.
          # This functionality is Experimental and may be changed or removed
          # completely in a future release. Elastic will take a best effort approach
          # to fix any issues, but experimental features are not subject to the
          # support SLA of official GA features.
          #
          # @option arguments [String] :model_id The ID of the trained models stats to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no trained models. (This includes `_all` string or when no trained models have been specified)
          # @option arguments [Int] :from skips a number of trained models
          # @option arguments [Int] :size specifies a max number of trained models to get
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/get-trained-models-stats.html
          #
          def get_trained_models_stats(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _model_id
                       "_ml/trained_models/#{Elasticsearch::API::Utils.__listify(_model_id)}/_stats"
                     else
                       "_ml/trained_models/_stats"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_trained_models_stats, [
            :allow_no_match,
            :from,
            :size
          ].freeze)
        end
      end
    end
  end
end
