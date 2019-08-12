# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Change the password of a user
          #
          # @option arguments [String] :username The username of the user to change the password for
          # @option arguments [Hash] :body the new password for the user (*Required*)
          # @option arguments [Boolean] :refresh Refresh the index after performing the operation
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-change-password.html
          #
          def change_password(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            arguments = arguments.clone
            username = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_PUT
            path   = Elasticsearch::API::Utils.__pathify "_xpack/security/user/", username, "/_password"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:change_password, [ :refresh ].freeze)
        end
      end
    end
  end
end
