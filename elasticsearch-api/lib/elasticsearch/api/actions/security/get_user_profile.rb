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
        # Retrieves user profiles for the given unique ID(s).
        #
        # @option arguments [List] :uid A comma-separated list of unique identifier for user profiles
        # @option arguments [List] :data A comma-separated list of keys for which the corresponding application data are retrieved.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/security-api-get-user-profile.html
        #
        def get_user_profile(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_user_profile' }

          defined_params = [:uid].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'uid' missing" unless arguments[:uid]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          _uid = arguments.delete(:uid)

          method = Elasticsearch::API::HTTP_GET
          path   = "_security/profile/#{Utils.__listify(_uid)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
