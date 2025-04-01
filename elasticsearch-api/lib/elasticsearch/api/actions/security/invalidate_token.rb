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
# Auto generated from commit 69cbe7cbe9f49a2886bb419ec847cffb58f8b4fb
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Security
      module Actions
        # Invalidate a token.
        # The access tokens returned by the get token API have a finite period of time for which they are valid.
        # After that time period, they can no longer be used.
        # The time period is defined by the +xpack.security.authc.token.timeout+ setting.
        # The refresh tokens returned by the get token API are only valid for 24 hours.
        # They can also be used exactly once.
        # If you want to invalidate one or more access or refresh tokens immediately, use this invalidate token API.
        # NOTE: While all parameters are optional, at least one of them is required.
        # More specifically, either one of +token+ or +refresh_token+ parameters is required.
        # If none of these two are specified, then +realm_name+ and/or +username+ need to be specified.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-invalidate-token
        #
        def invalidate_token(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.invalidate_token' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_DELETE
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
