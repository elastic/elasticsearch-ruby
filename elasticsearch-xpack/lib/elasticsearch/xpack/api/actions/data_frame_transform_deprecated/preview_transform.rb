# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrameTransformDeprecated
        module Actions
          # TODO: Description

          # @option arguments [Hash] :body The definition for the transform to preview (*Required*)
          #
          # *Deprecation notice*:
          # [_data_frame/transforms/] is deprecated, use [_transform/] in the future.
          # Deprecated since version 7.5.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/preview-transform.html
          #
          def preview_transform(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/_preview"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
