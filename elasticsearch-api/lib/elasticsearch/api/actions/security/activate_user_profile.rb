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
        # Activate a user profile.
        # Create or update a user profile on behalf of another user.
        # NOTE: The user profile feature is designed only for use by Kibana and Elastic's Observability, Enterprise Search, and Elastic Security solutions.
        # Individual users and external applications should not call this API directly.
        # The calling application must have either an +access_token+ or a combination of +username+ and +password+ for the user that the profile document is intended for.
        # Elastic reserves the right to change or remove this feature in future releases without prior notice.
        # This API creates or updates a profile document for end users with information that is extracted from the user's authentication object including +username+, +full_name,+ +roles+, and the authentication realm.
        # For example, in the JWT +access_token+ case, the profile user's +username+ is extracted from the JWT token claim pointed to by the +claims.principal+ setting of the JWT realm that authenticated the token.
        # When updating a profile document, the API enables the document if it was disabled.
        # Any updates do not change existing content for either the +labels+ or +data+ fields.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-activate-user-profile
        #
        def activate_user_profile(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.activate_user_profile' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = "_security/profile/_activate"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
