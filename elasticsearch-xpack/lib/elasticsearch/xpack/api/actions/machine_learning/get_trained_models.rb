# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :model_id The ID of the trained models to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no trained models. (This includes `_all` string or when no trained models have been specified)
          # @option arguments [Boolean] :include_model_definition Should the full model definition be included in the results. These definitions can be large. So be cautious when including them. Defaults to false.
          # @option arguments [Boolean] :decompress_definition Should the model definition be decompressed into valid JSON or returned in a custom compressed format. Defaults to true.
          # @option arguments [Int] :from skips a number of trained models
          # @option arguments [Int] :size specifies a max number of trained models to get

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/get-inference.html
          #
          def get_trained_models(arguments = {})
            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _model_id
                       "_ml/inference/#{Elasticsearch::API::Utils.__listify(_model_id)}"
                     else
                       "_ml/inference"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_trained_models, [
            :allow_no_match,
            :include_model_definition,
            :decompress_definition,
            :from,
            :size
          ].freeze)
      end
    end
    end
  end
end
