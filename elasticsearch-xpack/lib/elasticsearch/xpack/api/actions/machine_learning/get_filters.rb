# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieves filters.
          #
          # @option arguments [String] :filter_id The ID of the filter to fetch
          # @option arguments [Int] :from skips a number of filters
          # @option arguments [Int] :size specifies a max number of filters to get
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/ml-get-filter.html
          #
          def get_filters(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _filter_id = arguments.delete(:filter_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _filter_id
                       "_ml/filters/#{Elasticsearch::API::Utils.__listify(_filter_id)}"
                     else
                       "_ml/filters"
            end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_filters, [
            :from,
            :size
          ].freeze)
      end
    end
    end
  end
end
