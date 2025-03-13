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
        # Authenticate SAML.
        # Submit a SAML response message to Elasticsearch for consumption.
        # NOTE: This API is intended for use by custom web applications other than Kibana.
        # If you are using Kibana, refer to the documentation for configuring SAML single-sign-on on the Elastic Stack.
        # The SAML message that is submitted can be:
        # * A response to a SAML authentication request that was previously created using the SAML prepare authentication API.
        # * An unsolicited SAML message in the case of an IdP-initiated single sign-on (SSO) flow.
        # In either case, the SAML message needs to be a base64 encoded XML document with a root element of +<Response>+.
        # After successful validation, Elasticsearch responds with an Elasticsearch internal access token and refresh token that can be subsequently used for authentication.
        # This API endpoint essentially exchanges SAML responses that indicate successful authentication in the IdP for Elasticsearch access and refresh tokens, which can be used for authentication against Elasticsearch.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-saml-authenticate
        #
        def saml_authenticate(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.saml_authenticate' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/saml/authenticate'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
