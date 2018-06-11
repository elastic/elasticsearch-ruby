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
            path   = "_xpack/security/role_mapping/#{arguments[:name]}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
