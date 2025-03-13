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
        # Get a token.
        # Create a bearer token for access without requiring basic authentication.
        # The tokens are created by the Elasticsearch Token Service, which is automatically enabled when you configure TLS on the HTTP interface.
        # Alternatively, you can explicitly enable the +xpack.security.authc.token.enabled+ setting.
        # When you are running in production mode, a bootstrap check prevents you from enabling the token service unless you also enable TLS on the HTTP interface.
        # The get token API takes the same parameters as a typical OAuth 2.0 token API except for the use of a JSON request body.
        # A successful get token API call returns a JSON structure that contains the access token, the amount of time (seconds) that the token expires in, the type, and the scope if available.
        # The tokens returned by the get token API have a finite period of time for which they are valid and after that time period, they can no longer be used.
        # That time period is defined by the +xpack.security.authc.token.timeout+ setting.
        # If you want to invalidate a token immediately, you can do so by using the invalidate token API.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-token
        #
        def get_token(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_token' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/oauth2/token'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
