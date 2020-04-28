# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Cat
        module Actions
          # Gets configuration and usage information about inference trained models.
          #
          # @option arguments [String] :model_id The ID of the trained models stats to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no trained models. (This includes `_all` string or when no trained models have been specified)
          # @option arguments [Int] :from skips a number of trained models
          # @option arguments [Int] :size specifies a max number of trained models to get
          # @option arguments [String] :bytes The unit in which to display byte values
          #   (options: b,k,kb,m,mb,g,gb,t,tb,p,pb)

          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          # @option arguments [List] :h Comma-separated list of column names to display
          # @option arguments [Boolean] :help Return help information
          # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
          # @option arguments [String] :time The unit in which to display time values
          #   (options: d,h,m,s,ms,micros,nanos)

          # @option arguments [Boolean] :v Verbose mode. Display column headers
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/cat-trained-model.html
          #
          def ml_trained_models(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _model_id = arguments.delete(:model_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _model_id
                       "_cat/ml/trained_models/#{Elasticsearch::API::Utils.__listify(_model_id)}"
                     else
                       "_cat/ml/trained_models"
            end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:ml_trained_models, [
            :allow_no_match,
            :from,
            :size,
            :bytes,
            :format,
            :h,
            :help,
            :s,
            :time,
            :v
          ].freeze)
      end
    end
    end
  end
end
