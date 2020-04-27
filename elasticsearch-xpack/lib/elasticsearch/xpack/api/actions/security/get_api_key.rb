# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

          # Retrieves information for one or more API keys.
          #
          # @option arguments [String] :id An API key id. This parameter cannot be used with any of name, realm_name or username are used.
          #
          # @option arguments [String] :name An API key name. This parameter cannot be used with any of id, realm_name or username are used.
          #
          # @option arguments [String] :realm_name The name of an authentication realm. This parameter cannot be used with either id or name.
          #
          # @option arguments [String] :username The name of an authentication realm. This parameter cannot be used with either id or name.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-get-api-key.html
          #
          def get_api_key(arguments={})

            valid_params = [ :id,
                             :username,
                             :name,
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
