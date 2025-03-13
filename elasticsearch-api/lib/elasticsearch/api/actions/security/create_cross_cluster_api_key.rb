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
        # Create a cross-cluster API key.
        # Create an API key of the +cross_cluster+ type for the API key based remote cluster access.
        # A +cross_cluster+ API key cannot be used to authenticate through the REST interface.
        # IMPORTANT: To authenticate this request you must use a credential that is not an API key. Even if you use an API key that has the required privilege, the API returns an error.
        # Cross-cluster API keys are created by the Elasticsearch API key service, which is automatically enabled.
        # NOTE: Unlike REST API keys, a cross-cluster API key does not capture permissions of the authenticated user. The API key’s effective permission is exactly as specified with the +access+ property.
        # A successful request returns a JSON structure that contains the API key, its unique ID, and its name. If applicable, it also returns expiration information for the API key in milliseconds.
        # By default, API keys never expire. You can specify expiration information when you create the API keys.
        # Cross-cluster API keys can only be updated with the update cross-cluster API key API.
        # Attempting to update them with the update REST API key API or the bulk update REST API keys API will result in an error.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-create-cross-cluster-api-key
        #
        def create_cross_cluster_api_key(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.create_cross_cluster_api_key' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/cross_cluster/api_key'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
