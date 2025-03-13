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
        # Find API keys with a query.
        # Get a paginated list of API keys and their information.
        # You can optionally filter the results with a query.
        # To use this API, you must have at least the +manage_own_api_key+ or the +read_security+ cluster privileges.
        # If you have only the +manage_own_api_key+ privilege, this API returns only the API keys that you own.
        # If you have the +read_security+, +manage_api_key+, or greater privileges (including +manage_security+), this API returns all API keys regardless of ownership.
        #
        # @option arguments [Boolean] :with_limited_by Return the snapshot of the owner user's role descriptors associated with the API key.
        #  An API key's actual permission is the intersection of its assigned role descriptors and the owner user's role descriptors (effectively limited by it).
        #  An API key cannot retrieve any API key’s limited-by role descriptors (including itself) unless it has +manage_api_key+ or higher privileges.
        # @option arguments [Boolean] :with_profile_uid Determines whether to also retrieve the profile UID for the API key owner principal.
        #  If it exists, the profile UID is returned under the +profile_uid+ response field for each API key.
        # @option arguments [Boolean] :typed_keys Determines whether aggregation names are prefixed by their respective types in the response.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-query-api-keys
        #
        def query_api_keys(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.query_api_keys' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = '_security/_query/api_key'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
