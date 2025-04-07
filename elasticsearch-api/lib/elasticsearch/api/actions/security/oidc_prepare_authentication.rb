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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Security
      module Actions
        # Prepare OpenID connect authentication.
        # Create an oAuth 2.0 authentication request as a URL string based on the configuration of the OpenID Connect authentication realm in Elasticsearch.
        # The response of this API is a URL pointing to the Authorization Endpoint of the configured OpenID Connect Provider, which can be used to redirect the browser of the user in order to continue the authentication process.
        # Elasticsearch exposes all the necessary OpenID Connect related functionality with the OpenID Connect APIs.
        # These APIs are used internally by Kibana in order to provide OpenID Connect based authentication, but can also be used by other, custom web applications or other clients.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-oidc-prepare-authentication
        #
        def oidc_prepare_authentication(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.oidc_prepare_authentication' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/oidc/prepare'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
