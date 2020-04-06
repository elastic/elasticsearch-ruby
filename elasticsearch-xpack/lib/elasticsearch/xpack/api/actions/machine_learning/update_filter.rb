# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Updates the description of a filter, adds items, or removes items.
          #
          # @option arguments [String] :filter_id The ID of the filter to update

          # @option arguments [Hash] :body The filter update (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-update-filter.html
          #
          def update_filter(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]

            arguments = arguments.clone

            _filter_id = arguments.delete(:filter_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/filters/#{Elasticsearch::API::Utils.__listify(_filter_id)}/_update"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
