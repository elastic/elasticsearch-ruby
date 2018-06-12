module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Delete a role mapping
          #
          # @option arguments [String] :name Role-mapping name (*Required*)
          # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes. (options: true, false, wait_for)
          #
          # @see https://www.elastic.co/guide/en/x-pack/master/security-api-role-mapping.html#security-api-delete-role-mapping
          #
          def delete_role_mapping(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
            valid_params = [
              :name,
              :refresh ]

            arguments = arguments.clone
            name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/security/role_mapping/#{name}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
