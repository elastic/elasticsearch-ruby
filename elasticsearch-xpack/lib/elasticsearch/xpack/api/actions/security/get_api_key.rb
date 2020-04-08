# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Retrieves information for one or more API keys.
          #
          # @option arguments [String] :id API key id of the API key to be retrieved
          # @option arguments [String] :name API key name of the API key to be retrieved
          # @option arguments [String] :username user name of the user who created this API key to be retrieved
          # @option arguments [String] :realm_name realm name of the user who created this API key to be retrieved
          # @option arguments [Boolean] :owner flag to query API keys owned by the currently authenticated user
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-api-key.html
          #
          def get_api_key(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_GET
            path   = "_security/api_key"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_api_key, [
            :id,
            :name,
            :username,
            :realm_name,
            :owner
          ].freeze)
      end
    end
    end
  end
end
