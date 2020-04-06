# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Removes application privileges.
          #
          # @option arguments [String] :application Application name
          # @option arguments [String] :name Privilege name
          # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes.
          #   (options: true,false,wait_for)

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-delete-privilege.html
          #
          def delete_privileges(arguments = {})
            raise ArgumentError, "Required argument 'application' missing" unless arguments[:application]
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

            arguments = arguments.clone

            _application = arguments.delete(:application)

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/privilege/#{Elasticsearch::API::Utils.__listify(_application)}/#{Elasticsearch::API::Utils.__listify(_name)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:delete_privileges, [
            :refresh
          ].freeze)
      end
    end
    end
  end
end
