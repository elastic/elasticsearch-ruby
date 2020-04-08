# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Transform
        module Actions
          # Previews a transform.
          #
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The definition for the transform to preview (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/preview-transform.html
          #
          def preview_transform(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_transform/_preview"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
