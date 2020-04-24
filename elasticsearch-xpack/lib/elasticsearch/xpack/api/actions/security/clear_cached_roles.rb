# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Clears the internal caches for specified roles
          #
          # @option arguments [String] :name Role name (*Required*)
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-roles.html#security-api-clear-role-cache
          #
          def clear_cached_roles(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/security/role/#{arguments[:name]}/_clear_cache"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
