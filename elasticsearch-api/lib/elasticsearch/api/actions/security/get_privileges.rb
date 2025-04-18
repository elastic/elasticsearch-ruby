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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Security
      module Actions
        # Get application privileges.
        # To use this API, you must have one of the following privileges:
        # * The +read_security+ cluster privilege (or a greater privilege such as +manage_security+ or +all+).
        # * The "Manage Application Privileges" global privilege for the application being referenced in the request.
        #
        # @option arguments [String] :application The name of the application.
        #  Application privileges are always associated with exactly one application.
        #  If you do not specify this parameter, the API returns information about all privileges for all applications.
        # @option arguments [String, Array<String>] :name The name of the privilege.
        #  If you do not specify this parameter, the API returns information about all privileges for the requested application.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-privileges
        #
        def get_privileges(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_privileges' }

          defined_params = [:application, :name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _application = arguments.delete(:application)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_GET
          path   = if _application && _name
                     "_security/privilege/#{Utils.listify(_application)}/#{Utils.listify(_name)}"
                   elsif _application
                     "_security/privilege/#{Utils.listify(_application)}"
                   else
                     '_security/privilege'
                   end
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
