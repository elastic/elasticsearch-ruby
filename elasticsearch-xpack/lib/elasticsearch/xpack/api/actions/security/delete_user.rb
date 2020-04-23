# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Remove a user from the native realm
          #
          # @option arguments [String] :username username (*Required*)
          # @option arguments [Boolean] :refresh Refresh the index after performing the operation
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-users.html#security-api-delete-user
          #
          def delete_user(arguments={})
            valid_params = [
              :username,
              :refresh ]

            arguments = arguments.clone
            username  = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/security/user/#{username}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
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
