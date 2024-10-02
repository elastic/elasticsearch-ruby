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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Security
      module Actions
        # Retrieves information for API keys using a subset of query DSL
        #
        # @option arguments [Boolean] :with_limited_by flag to show the limited-by role descriptors of API Keys
        # @option arguments [Boolean] :with_profile_uid flag to also retrieve the API Key's owner profile uid, if it exists
        # @option arguments [Boolean] :typed_keys flag to prefix aggregation names by their respective types in the response
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body From, size, query, sort and search_after
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/security-api-query-api-key.html
        #
        def query_api_keys(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.query_api_keys' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path = '_security/_query/api_key'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
