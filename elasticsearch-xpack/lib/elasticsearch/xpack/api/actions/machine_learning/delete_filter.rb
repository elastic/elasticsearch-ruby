# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Deletes a filter.
          #
          # @option arguments [String] :filter_id The ID of the filter to delete

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-delete-filter.html
          #
          def delete_filter(arguments = {})
            raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]

            arguments = arguments.clone

            _filter_id = arguments.delete(:filter_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/filters/#{Elasticsearch::API::Utils.__listify(_filter_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
