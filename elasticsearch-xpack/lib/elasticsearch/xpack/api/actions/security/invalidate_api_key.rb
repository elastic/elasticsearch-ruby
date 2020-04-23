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

          # Creates an API key for access without requiring basic authentication.
          #
          # @option arguments [Hash] :body The api key request to invalidate API key(s). (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-invalidate-api-key.html
          #
          def invalidate_api_key(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_security/api_key"
            params = {}

            perform_request(method, path, params, arguments[:body]).body
          end
        end
      end
    end
  end
end
