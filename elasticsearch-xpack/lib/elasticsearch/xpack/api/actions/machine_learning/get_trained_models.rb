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
          # Retrieves configuration information for a trained inference model.
          # This functionality is in Beta and is subject to change. The design and
          # code is less mature than official GA features and is being provided
          # as-is with no warranties. Beta features are not subject to the support
          # SLA of official GA features.
          #
          # @option arguments [String] :model_id The ID of the trained models to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no trained models. (This includes `_all` string or when no trained models have been specified)
          # @option arguments [String] :include A comma-separate list of fields to optionally include. Valid options are 'definition' and 'total_feature_importance'. Default is none.
          # @option arguments [Boolean] :include_model_definition Should the full model definition be included in the results. These definitions can be large. So be cautious when including them. Defaults to false. *Deprecated*
          # @option arguments [Boolean] :decompress_definition Should the model definition be decompressed into valid JSON or returned in a custom compressed format. Defaults to true.
          # @option arguments [Int] :from skips a number of trained models
          # @option arguments [Int] :size specifies a max number of trained models to get
          # @option arguments [List] :tags A comma-separated list of tags that the model must have.
          # @option arguments [Boolean] :exclude_generated Omits fields that are illegal to set on model PUT
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/get-trained-models.html
          #
          def get_trained_models(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _model_id
                       "_ml/trained_models/#{Elasticsearch::API::Utils.__listify(_model_id)}"
                     else
                       "_ml/trained_models"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_trained_models, [
            :allow_no_match,
            :include,
            :include_model_definition,
            :decompress_definition,
            :from,
            :size,
            :tags,
            :exclude_generated
          ].freeze)
        end
      end
    end
  end
end
