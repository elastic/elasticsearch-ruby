# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Retrieve details about the currently authenticated user
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-authenticate.html
          #
          def authenticate(arguments={})
            valid_params = []
            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/security/_authenticate"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
