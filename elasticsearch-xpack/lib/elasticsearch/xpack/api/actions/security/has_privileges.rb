# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Determines whether the specified user has a specified list of privileges.
          #
          # @option arguments [String] :user Username
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The privileges to test (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-has-privileges.html
          #
          def has_privileges(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _user = arguments.delete(:user)

            method = Elasticsearch::API::HTTP_GET
            path   = if _user
                       "_security/user/#{Elasticsearch::API::Utils.__listify(_user)}/_has_privileges"
                     else
                       "_security/user/_has_privileges"
  end
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
