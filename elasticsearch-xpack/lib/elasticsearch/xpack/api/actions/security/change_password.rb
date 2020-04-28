# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Changes the passwords of users in the native realm and built-in users.
          #
          # @option arguments [String] :username The username of the user to change the password for
          # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes.
          #   (options: true,false,wait_for)

          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body the new password for the user (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/security-api-change-password.html
          #
          def change_password(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _username = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_PUT
            path   = if _username
                       "_security/user/#{Elasticsearch::API::Utils.__listify(_username)}/_password"
                     else
                       "_security/user/_password"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:change_password, [
            :refresh
          ].freeze)
      end
    end
    end
  end
end
