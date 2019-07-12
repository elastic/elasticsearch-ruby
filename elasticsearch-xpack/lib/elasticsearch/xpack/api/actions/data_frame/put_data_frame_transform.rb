# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions

          # Instantiates a data frame transform.
          #
          # @option arguments [Hash] :transform_id The id of the new transform. *Required*
          # @option arguments [Hash] :body The data frame transform definition. *Required*
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/put-data-frame-transform.html
          #
          # @since 7.2.0
          def put_data_frame_transform(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            transform_id = URI.escape(arguments[:transform_id])
            body = arguments[:body]

            method = Elasticsearch::API::HTTP_PUT
            path   = "_data_frame/transforms/#{transform_id}"
            params = {}

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
