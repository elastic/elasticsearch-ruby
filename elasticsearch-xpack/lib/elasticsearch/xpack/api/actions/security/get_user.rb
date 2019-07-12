# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Retrieve one or more users from the native realm
          #
          # @option arguments [List] :username A comma-separated list of usernames
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-users.html#security-api-get-user
          #
          def get_user(arguments={})
            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify "_security/user", Elasticsearch::API::Utils.__listify(arguments[:username])
            params = {}
            body   = nil

            if Array(arguments[:ignore]).include?(404)
              Elasticsearch::API::Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
            else
              perform_request(method, path, params, body).body
            end
          end
        end
      end
    end
  end
end
