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
        # Get user privileges.
        # Get the security privileges for the logged in user.
        # All users can use this API, but only to determine their own privileges.
        # To check the privileges of other users, you must use the run as feature.
        # To check whether a user has a specific list of privileges, use the has privileges API.
        #
        # @option arguments [String] :application The name of the application. Application privileges are always associated with exactly one application. If you do not specify this parameter, the API returns information about all privileges for all applications.
        # @option arguments [String] :priviledge The name of the privilege. If you do not specify this parameter, the API returns information about all privileges for the requested application.
        # @option arguments [Name, Null] :username [TODO]
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-user-privileges
        #
        def get_user_privileges(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_user_privileges' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_security/user/_privileges'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
