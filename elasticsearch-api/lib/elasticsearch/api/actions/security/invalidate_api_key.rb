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
        # Invalidate API keys.
        # This API invalidates API keys created by the create API key or grant API key APIs.
        # Invalidated API keys fail authentication, but they can still be viewed using the get API key information and query API key information APIs, for at least the configured retention period, until they are automatically deleted.
        # To use this API, you must have at least the +manage_security+, +manage_api_key+, or +manage_own_api_key+ cluster privileges.
        # The +manage_security+ privilege allows deleting any API key, including both REST and cross cluster API keys.
        # The +manage_api_key+ privilege allows deleting any REST API key, but not cross cluster API keys.
        # The +manage_own_api_key+ only allows deleting REST API keys that are owned by the user.
        # In addition, with the +manage_own_api_key+ privilege, an invalidation request must be issued in one of the three formats:
        # - Set the parameter +owner=true+.
        # - Or, set both +username+ and +realm_name+ to match the user's identity.
        # - Or, if the request is issued by an API key, that is to say an API key invalidates itself, specify its ID in the +ids+ field.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-invalidate-api-key
        #
        def invalidate_api_key(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.invalidate_api_key' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_DELETE
          path   = '_security/api_key'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
