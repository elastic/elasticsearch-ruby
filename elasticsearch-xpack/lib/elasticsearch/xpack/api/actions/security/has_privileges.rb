# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Remove a role from the native realm
          #
          # @option arguments [String] :user Username
          # @option arguments [String] :body The privileges to test (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-has-privileges.html
          #
          def has_privileges(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_GET

            path   = Elasticsearch::API::Utils.__pathify "_xpack/security/user", arguments[:user], "_has_privileges"

            perform_request(method, path, {}, arguments[:body]).body
          end
        end
      end
    end
  end
end
