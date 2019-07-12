# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Retrieve the mapping for a role
          #
          # @option arguments [String] :name Role-Mapping name
          #
          # @see https://www.elastic.co/guide/en/x-pack/master/security-api-role-mapping.html#security-api-get-role-mapping
          #
          def get_role_mapping(arguments={})
            method = Elasticsearch::API::HTTP_GET
            path   = "_security/role_mapping/#{Elasticsearch::API::Utils.__listify(arguments[:name])}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
