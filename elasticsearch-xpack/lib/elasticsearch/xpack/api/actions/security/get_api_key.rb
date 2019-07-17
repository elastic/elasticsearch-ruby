# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Creates an API key for access without requiring basic authentication.
          #
          # @option arguments [String] :id API key id of the API key to be retrieved.
          #
          # @option arguments [String] :name API key name of the API key to be retrieved.
          #
          # @option arguments [String] :username user name of the user who created this API key to be retrieved.
          #
          # @option arguments [String] :realm_name realm name of the user who created this API key to be retrieved.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-api-key.html
          #
          def get_api_key(arguments={})

            valid_params = [ :id,
                             :name,
                             :username,
                             :realm_name ]

            method = Elasticsearch::API::HTTP_GET
            path   = "_security/api_key"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params

            perform_request(method, path, params).body
          end
        end
      end
    end
  end
end
