# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions

          # Deletes an existing data frame transform.
          #
          # @option arguments [String] :transform_id The id of the transform to delete. *Required*
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/delete-data-frame-transform.html
          #
          # @since 7.2.0
          def delete_data_frame_transform(arguments={})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]
            transform_id = URI.escape(arguments[:transform_id])

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_data_frame/transforms/#{transform_id}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
