# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Migration
        module Actions

          # Perform the upgrade of internal indices to make them compatible with the next major version
          #
          # @option arguments [String] :index The name of the index (*Required*)
          # @option arguments [Boolean] :wait_for_completion Should the request block until the upgrade operation is completed
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/migration-api-upgrade.html
          #
          def upgrade(arguments={})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify "_xpack/migration/upgrade", arguments[:index]
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:upgrade, [ :wait_for_completion ].freeze)
        end
      end
    end
  end
end
