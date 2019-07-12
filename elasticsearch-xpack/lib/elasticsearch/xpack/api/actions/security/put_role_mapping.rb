# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Add a mapping for a role
          #
          # @option arguments [String] :name Role-mapping name (*Required*)
          # @option arguments [Hash] :body The role to add (*Required*)
          # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes. (options: true, false, wait_for)
          #
          # @see https://www.elastic.co/guide/en/x-pack/master/security-api-role-mapping.html#security-api-put-role-mapping
          #
          def put_role_mapping(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            valid_params = [
              :name,
              :refresh ]

            arguments = arguments.clone
            name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_security/role_mapping/#{name}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
