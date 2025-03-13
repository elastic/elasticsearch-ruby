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
        # Suggest a user profile.
        # Get suggestions for user profiles that match specified search criteria.
        # NOTE: The user profile feature is designed only for use by Kibana and Elastic's Observability, Enterprise Search, and Elastic Security solutions.
        # Individual users and external applications should not call this API directly.
        # Elastic reserves the right to change or remove this feature in future releases without prior notice.
        #
        # @option arguments [String] :data A comma-separated list of filters for the +data+ field of the profile document.
        #  To return all content use +data=*+.
        #  To return a subset of content, use +data=<key>+ to retrieve content nested under the specified +<key>+.
        #  By default, the API returns no +data+ content.
        #  It is an error to specify +data+ as both the query parameter and the request body field.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-suggest-user-profiles
        #
        def suggest_user_profiles(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.suggest_user_profiles' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = '_security/profile/_suggest'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
