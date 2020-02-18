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
          # @option arguments [String] :name Role-Mapping name

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-role-mapping.html
          #
          def get_role_mapping(arguments = {})
            arguments = arguments.clone

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_GET
            path   = if _name
                       "_security/role_mapping/#{Elasticsearch::API::Utils.__listify(_name)}"
                     else
                       "_security/role_mapping"
  end
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
