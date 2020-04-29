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
          # Retrieves information about users in the native realm and built-in users.
          #
          # @option arguments [List] :username A comma-separated list of usernames
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-user.html
          #
          def get_user(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _username = arguments.delete(:username)

            method = Elasticsearch::API::HTTP_GET
            path   = if _username
                       "_security/user/#{Elasticsearch::API::Utils.__listify(_username)}"
                     else
                       "_security/user"
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
