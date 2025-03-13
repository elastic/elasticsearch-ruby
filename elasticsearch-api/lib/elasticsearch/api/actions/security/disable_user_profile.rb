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
        # Disable a user profile.
        # Disable user profiles so that they are not visible in user profile searches.
        # NOTE: The user profile feature is designed only for use by Kibana and Elastic's Observability, Enterprise Search, and Elastic Security solutions.
        # Individual users and external applications should not call this API directly.
        # Elastic reserves the right to change or remove this feature in future releases without prior notice.
        # When you activate a user profile, its automatically enabled and visible in user profile searches. You can use the disable user profile API to disable a user profile so it’s not visible in these searches.
        # To re-enable a disabled user profile, use the enable user profile API .
        #
        # @option arguments [String] :uid Unique identifier for the user profile. (*Required*)
        # @option arguments [String] :refresh If 'true', Elasticsearch refreshes the affected shards to make this operation visible to search.
        #  If 'wait_for', it waits for a refresh to make this operation visible to search.
        #  If 'false', it does nothing with refreshes. Server default: false.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-disable-user-profile
        #
        def disable_user_profile(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.disable_user_profile' }

          defined_params = [:uid].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'uid' missing" unless arguments[:uid]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _uid = arguments.delete(:uid)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_security/profile/#{Utils.listify(_uid)}/_disable"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
