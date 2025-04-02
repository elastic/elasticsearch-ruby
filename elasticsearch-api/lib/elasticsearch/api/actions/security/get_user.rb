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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Security
      module Actions
        # Get users.
        # Get information about users in the native realm and built-in users.
        #
        # @option arguments [Username] :username An identifier for the user. You can specify multiple usernames as a comma-separated list. If you omit this parameter, the API retrieves information about all users.
        # @option arguments [Boolean] :with_profile_uid Determines whether to retrieve the user profile UID, if it exists, for the users.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-user
        #
        def get_user(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_user' }

          defined_params = [:username].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _username = arguments.delete(:username)

          method = Elasticsearch::API::HTTP_GET
          path   = if _username
                     "_security/user/#{Utils.listify(_username)}"
                   else
                     '_security/user'
                   end
          params = Utils.process_params(arguments)

          if Array(arguments[:ignore]).include?(404)
            Utils.rescue_from_not_found do
              Elasticsearch::API::Response.new(
                perform_request(method, path, params, body, headers, request_opts)
              )
            end
          else
            Elasticsearch::API::Response.new(
              perform_request(method, path, params, body, headers, request_opts)
            )
          end
        end
      end
    end
  end
end
