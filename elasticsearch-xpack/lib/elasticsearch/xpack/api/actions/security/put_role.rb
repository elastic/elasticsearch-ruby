# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Update or create a role for the native shield realm
          #
          # @option arguments [String] :name Role name (*Required*)
          # @option arguments [Hash] :body The role to add (*Required*)
          # @option arguments [Boolean] :refresh Refresh the index after performing the operation
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-roles.html#security-api-put-role
          #
          def put_role(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/security/role/#{arguments[:name]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:put_role, [ :refresh ].freeze)
        end
      end
    end
  end
end
