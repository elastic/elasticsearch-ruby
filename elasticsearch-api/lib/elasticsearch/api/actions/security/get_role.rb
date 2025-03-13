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
        # Get roles.
        # Get roles in the native realm.
        # The role management APIs are generally the preferred way to manage roles, rather than using file-based role management.
        # The get roles API cannot retrieve roles that are defined in roles files.
        #
        # @option arguments [String, Array<String>] :name The name of the role.
        #  You can specify multiple roles as a comma-separated list.
        #  If you do not specify this parameter, the API returns information about all roles.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-role
        #
        def get_role(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_role' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_GET
          path   = if _name
                     "_security/role/#{Utils.listify(_name)}"
                   else
                     '_security/role'
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
