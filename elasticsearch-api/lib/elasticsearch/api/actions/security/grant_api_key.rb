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
        # Grant an API key.
        # Create an API key on behalf of another user.
        # This API is similar to the create API keys API, however it creates the API key for a user that is different than the user that runs the API.
        # The caller must have authentication credentials for the user on whose behalf the API key will be created.
        # It is not possible to use this API to create an API key without that user's credentials.
        # The supported user authentication credential types are:
        # * username and password
        # * Elasticsearch access tokens
        # * JWTs
        # The user, for whom the authentication credentials is provided, can optionally "run as" (impersonate) another user.
        # In this case, the API key will be created on behalf of the impersonated user.
        # This API is intended be used by applications that need to create and manage API keys for end users, but cannot guarantee that those users have permission to create API keys on their own behalf.
        # The API keys are created by the Elasticsearch API key service, which is automatically enabled.
        # A successful grant API key API call returns a JSON structure that contains the API key, its unique id, and its name.
        # If applicable, it also returns expiration information for the API key in milliseconds.
        # By default, API keys never expire. You can specify expiration information when you create the API keys.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-grant-api-key
        #
        def grant_api_key(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.grant_api_key' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/api_key/grant'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
