# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions
          # Previews a data frame transform.
          #
          # @option arguments [Hash] :body The definition for the data_frame transform to preview. *Required*
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/preview-data-frame-transform.html
          #
          # @sicne 7.2.0
          def preview_data_frame_transform(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_POST
            path   = '_data_frame/transforms/_preview'
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
