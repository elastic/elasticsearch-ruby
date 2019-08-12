# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Disable a user
          #
          # @option arguments [String] :username The username of the user to disable
          # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this
          # operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search,
          # if `false` then do nothing with refreshes. (options: true, false, wait_for)
          #
          # @see https://www.elastic.co/guide/en/x-pack/5.4/security-api-users.html
          #
          def disable_user(arguments={})
            arguments = arguments.clone
            username = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/security/user/#{username}/_disable"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:disable_user, [ :username,
                                                   :refresh ].freeze)
        end
      end
    end
  end
end
