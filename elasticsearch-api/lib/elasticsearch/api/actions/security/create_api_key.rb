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
#
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Security
      module Actions
        # Create an API key.
        # Create an API key for access without requiring basic authentication.
        # IMPORTANT: If the credential that is used to authenticate this request is an API key, the derived API key cannot have any privileges.
        # If you specify privileges, the API returns an error.
        # A successful request returns a JSON structure that contains the API key, its unique id, and its name.
        # If applicable, it also returns expiration information for the API key in milliseconds.
        # NOTE: By default, API keys never expire. You can specify expiration information when you create the API keys.
        # The API keys are created by the Elasticsearch API key service, which is automatically enabled.
        # To configure or turn off the API key service, refer to API key service setting documentation.
        #
        # @option arguments [String] :refresh If +true+ (the default) then refresh the affected shards to make this operation visible to search, if +wait_for+ then wait for a refresh to make this operation visible to search, if +false+ then do nothing with refreshes.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-create-api-key
        #
        def create_api_key(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.create_api_key' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_PUT
          path   = '_security/api_key'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
