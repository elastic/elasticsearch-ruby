# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Instantiates a data frame analytics job.
          #
          # @option arguments [String] :id The ID of the data frame analytics to create
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The data frame analytics configuration (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/put-dfanalytics.html
          #
          def put_data_frame_analytics(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
