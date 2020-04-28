# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Retrieves information about users in the native realm and built-in users.
          #
          # @option arguments [List] :username A comma-separated list of usernames
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/security-api-get-user.html
          #
          def get_user(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _username = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_GET
            path   = if _username
                       "_security/user/#{Elasticsearch::API::Utils.__listify(_username)}"
                     else
                       "_security/user"
            end
            params = {}

            body = nil
            if Array(arguments[:ignore]).include?(404)
              Elasticsearch::API::Utils.__rescue_from_not_found { perform_request(method, path, params, body, headers).body }
            else
              perform_request(method, path, params, body, headers).body
            end
          end
      end
    end
    end
  end
end
