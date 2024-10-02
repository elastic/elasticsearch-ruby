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
        # Update application specific data for the user profile of the given unique ID.
        #
        # @option arguments [String] :uid An unique identifier of the user profile
        # @option arguments [Number] :if_seq_no only perform the update operation if the last operation that has changed the document has the specified sequence number
        # @option arguments [Number] :if_primary_term only perform the update operation if the last operation that has changed the document has the specified primary term
        # @option arguments [String] :refresh If `true` (the default) then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes. (options: true, false, wait_for)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The application data to update (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/security-api-update-user-profile-data.html
        #
        def update_user_profile_data(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.update_user_profile_data' }

          defined_params = [:uid].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'uid' missing" unless arguments[:uid]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _uid = arguments.delete(:uid)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_security/profile/#{Utils.__listify(_uid)}/_data"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
