# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Retrieves roles in the native realm.
          #
          # @option arguments [String] :name Role name
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-role.html
          #
          def get_role(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_GET
            path   = if _name
                       "_security/role/#{Elasticsearch::API::Utils.__listify(_name)}"
                     else
                       "_security/role"
            end
            params = {}

            body = nil
            if Array(arguments[:ignore]).include?(404)
              Elasticsearch::API::Utils.__rescue_from_not_found { perform_request(method, path, params, body, headers).body }
            else
              perform_request(method, path, params, body, headers).body
            end
          end
      end
    end
    end
  end
end
