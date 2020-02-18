# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # TODO: Description

          #
          # @option arguments [List] :realms Comma-separated list of realms to clear
          # @option arguments [List] :usernames Comma-separated list of usernames to clear from the cache

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-clear-cache.html
          #
          def clear_cached_realms(arguments = {})
            raise ArgumentError, "Required argument 'realms' missing" unless arguments[:realms]

            arguments = arguments.clone

            _realms = arguments.delete(:realms)

            method = Elasticsearch::API::HTTP_POST
            path   = "_security/realm/#{Elasticsearch::API::Utils.__listify(_realms)}/_clear_cache"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:clear_cached_realms, [
            :usernames
          ].freeze)
      end
    end
    end
  end
end
