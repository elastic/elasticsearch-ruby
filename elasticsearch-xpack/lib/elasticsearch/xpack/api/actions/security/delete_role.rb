# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Remove a role from the native realm
          #
          # @option arguments [String] :name Role name (*Required*)
          # @option arguments [Boolean] :refresh Refresh the index after performing the operation
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-roles.html#security-api-delete-role
          #
          def delete_role(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/role/#{arguments[:name]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            if Array(arguments[:ignore]).include?(404)
              Elasticsearch::API::Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
            else
              perform_request(method, path, params, body).body
            end
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:delete_role, [ :refresh ].freeze)
        end
      end
    end
  end
end
