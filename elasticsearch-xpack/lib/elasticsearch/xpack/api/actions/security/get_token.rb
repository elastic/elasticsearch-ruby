# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # TODO: Description

          # @option arguments [Hash] :body The token request to get (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-token.html
          #
          def get_token(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_security/oauth2/token"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
