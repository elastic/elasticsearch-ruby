# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Creates an API key for access without requiring basic authentication.
          #
          # @option arguments [Hash] :body The api key request to invalidate API key(s). (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-invalidate-api-key.html
          #
          def invalidate_api_key(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/api_key"
            params = {}

            perform_request(method, path, params, arguments[:body]).body
          end
        end
      end
    end
  end
end
