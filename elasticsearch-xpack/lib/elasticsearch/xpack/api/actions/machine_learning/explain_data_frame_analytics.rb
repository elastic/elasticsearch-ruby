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
          # @option arguments [String] :id The ID of the data frame analytics to explain

          # @option arguments [Hash] :body The data frame analytics config to explain
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/explain-dfanalytics.html
          #
          def explain_data_frame_analytics(arguments = {})
            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _id
                       "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}/_explain"
                     else
                       "_ml/data_frame/analytics/_explain"
  end
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
