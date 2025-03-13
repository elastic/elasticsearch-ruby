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
        # Bulk update API keys.
        # Update the attributes for multiple API keys.
        # IMPORTANT: It is not possible to use an API key as the authentication credential for this API. To update API keys, the owner user's credentials are required.
        # This API is similar to the update API key API but enables you to apply the same update to multiple API keys in one API call. This operation can greatly improve performance over making individual updates.
        # It is not possible to update expired or invalidated API keys.
        # This API supports updates to API key access scope, metadata and expiration.
        # The access scope of each API key is derived from the +role_descriptors+ you specify in the request and a snapshot of the owner user's permissions at the time of the request.
        # The snapshot of the owner's permissions is updated automatically on every call.
        # IMPORTANT: If you don't specify +role_descriptors+ in the request, a call to this API might still change an API key's access scope. This change can occur if the owner user's permissions have changed since the API key was created or last modified.
        # A successful request returns a JSON structure that contains the IDs of all updated API keys, the IDs of API keys that already had the requested changes and did not require an update, and error details for any failed update.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-bulk-update-api-keys
        #
        def bulk_update_api_keys(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.bulk_update_api_keys' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/api_key/_bulk_update'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
