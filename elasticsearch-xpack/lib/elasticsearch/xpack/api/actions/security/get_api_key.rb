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
            method = Elasticsearch::API::HTTP_GET
            path   = "_security/api_key"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            perform_request(method, path, params).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_api_key, [ :id,
                                                  :name,
                                                  :username,
                                                  :realm_name ].freeze)
        end
      end
    end
  end
end
