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
          # Adds and updates users in the native realm. These users are commonly referred to as native users.
          #
          # @option arguments [String] :username The username of the User
          # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes.
          #   (options: true,false,wait_for)
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The user to add (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/security-api-put-user.html
          #
          def put_user(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'username' missing" unless arguments[:username]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _username = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_security/user/#{Elasticsearch::API::Utils.__listify(_username)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:put_user, [
            :refresh
          ].freeze)
        end
      end
    end
  end
end
