# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions
          # Deletes a service account token.
          # This functionality is in Beta and is subject to change. The design and
          # code is less mature than official GA features and is being provided
          # as-is with no warranties. Beta features are not subject to the support
          # SLA of official GA features.
          #
          # @option arguments [String] :namespace An identifier for the namespace
          # @option arguments [String] :service An identifier for the service name
          # @option arguments [String] :name An identifier for the token name
          # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` (the default) then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes. (options: true, false, wait_for)
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.15/security-api-delete-service-token.html
          #
          def delete_service_token(arguments = {})
            raise ArgumentError, "Required argument 'namespace' missing" unless arguments[:namespace]
            raise ArgumentError, "Required argument 'service' missing" unless arguments[:service]
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _namespace = arguments.delete(:namespace)

            _service = arguments.delete(:service)

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/service/#{Elasticsearch::API::Utils.__listify(_namespace)}/#{Elasticsearch::API::Utils.__listify(_service)}/credential/token/#{Elasticsearch::API::Utils.__listify(_name)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:delete_service_token, [
            :refresh
          ].freeze)
        end
      end
    end
  end
end
