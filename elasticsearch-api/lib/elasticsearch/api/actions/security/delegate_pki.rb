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
        # Delegate PKI authentication.
        # This API implements the exchange of an X509Certificate chain for an Elasticsearch access token.
        # The certificate chain is validated, according to RFC 5280, by sequentially considering the trust configuration of every installed PKI realm that has +delegation.enabled+ set to +true+.
        # A successfully trusted client certificate is also subject to the validation of the subject distinguished name according to thw +username_pattern+ of the respective realm.
        # This API is called by smart and trusted proxies, such as Kibana, which terminate the user's TLS session but still want to authenticate the user by using a PKI realm—-​as if the user connected directly to Elasticsearch.
        # IMPORTANT: The association between the subject public key in the target certificate and the corresponding private key is not validated.
        # This is part of the TLS authentication process and it is delegated to the proxy that calls this API.
        # The proxy is trusted to have performed the TLS authentication and this API translates that authentication into an Elasticsearch access token.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-security-delegate-pki
        #
        def delegate_pki(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.delegate_pki' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_security/delegate_pki'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
