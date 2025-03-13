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
        # Prepare SAML authentication.
        # Create a SAML authentication request (+<AuthnRequest>+) as a URL string based on the configuration of the respective SAML realm in Elasticsearch.
        # NOTE: This API is intended for use by custom web applications other than Kibana.
        # If you are using Kibana, refer to the documentation for configuring SAML single-sign-on on the Elastic Stack.
        # This API returns a URL pointing to the SAML Identity Provider.
        # You can use the URL to redirect the browser of the user in order to continue the authentication process.
        # The URL includes a single parameter named +SAMLRequest+, which contains a SAML Authentication request that is deflated and Base64 encoded.
        # If the configuration dictates that SAML authentication requests should be signed, the URL has two extra parameters named +SigAlg+ and +Signature+.
        # These parameters contain the algorithm used for the signature and the signature value itself.
        # It also returns a random string that uniquely identifies this SAML Authentication request.
        # The caller of this API needs to store this identifier as it needs to be used in a following step of the authentication process.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-saml-prepare-authentication
        #
        def saml_prepare_authentication(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.saml_prepare_authentication' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/saml/prepare'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
