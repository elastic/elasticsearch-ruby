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
          # @option arguments [String] :id The ID of the data frame analytics to delete

          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/delete-dfanalytics.html
          #
          def delete_data_frame_analytics(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
