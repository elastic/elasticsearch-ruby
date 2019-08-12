# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Clears the internal user caches for specified realms
          #
          # @option arguments [String] :realms Comma-separated list of realms to clear (*Required*)
          # @option arguments [String] :usernames Comma-separated list of usernames to clear from the cache
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-clear-cache.html
          #
          def clear_cached_realms(arguments={})
            raise ArgumentError, "Required argument 'realms' missing" unless arguments[:realms]
            arguments = arguments.clone
            realms = arguments.delete(:realms)

            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify "_security/realm/", Elasticsearch::API::Utils.__listify(realms), "_clear_cache"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:clear_cached_realms, [ :usernames ].freeze)
        end
      end
    end
  end
end
