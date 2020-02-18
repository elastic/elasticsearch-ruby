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
          # @option arguments [List] :name Role name

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-clear-role-cache.html
          #
          def clear_cached_roles(arguments = {})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

            arguments = arguments.clone

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_POST
            path   = "_security/role/#{Elasticsearch::API::Utils.__listify(_name)}/_clear_cache"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
