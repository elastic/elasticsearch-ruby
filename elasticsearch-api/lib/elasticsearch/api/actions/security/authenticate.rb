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
        # Authenticate a user.
        # Authenticates a user and returns information about the authenticated user.
        # Include the user information in a {https://en.wikipedia.org/wiki/Basic_access_authentication basic auth header}.
        # A successful call returns a JSON structure that shows user information such as their username, the roles that are assigned to the user, any assigned metadata, and information about the realms that authenticated and authorized the user.
        # If the user cannot be authenticated, this API returns a 401 status code.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-authenticate
        #
        def authenticate(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.authenticate' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_security/_authenticate'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
