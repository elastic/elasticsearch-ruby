# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Retrieves application privileges.
          #
          # @option arguments [String] :application Application name
          # @option arguments [String] :name Privilege name
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/security-api-get-privileges.html
          #
          def get_privileges(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _application = arguments.delete(:application)

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_GET
            path   = if _application && _name
                       "_security/privilege/#{Elasticsearch::API::Utils.__listify(_application)}/#{Elasticsearch::API::Utils.__listify(_name)}"
                     elsif _application
                       "_security/privilege/#{Elasticsearch::API::Utils.__listify(_application)}"
                     else
                       "_security/privilege"
            end
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
