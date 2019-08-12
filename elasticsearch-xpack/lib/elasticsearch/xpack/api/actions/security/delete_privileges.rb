# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # @option arguments [String] :application Application name (*Required*)
          # @option arguments [Boolean] :name Privilege name (*Required*)
          #
          def delete_privileges(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
            raise ArgumentError, "Required argument 'application' missing" unless arguments[:application]

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/privilege/#{arguments.delete(:application)}/#{arguments[:name]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:delete_privileges, [ :refresh ].freeze)
        end
      end
    end
  end
end
