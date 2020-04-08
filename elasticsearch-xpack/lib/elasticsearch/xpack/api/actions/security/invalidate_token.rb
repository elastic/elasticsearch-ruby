# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Invalidates one or more access tokens or refresh tokens.
          #
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The token to invalidate (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-invalidate-token.html
          #
          def invalidate_token(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/oauth2/token"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
