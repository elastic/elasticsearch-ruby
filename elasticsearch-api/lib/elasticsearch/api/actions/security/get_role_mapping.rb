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
# Auto generated from commit 69cbe7cbe9f49a2886bb419ec847cffb58f8b4fb
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Security
      module Actions
        # Get role mappings.
        # Role mappings define which roles are assigned to each user.
        # The role mapping APIs are generally the preferred way to manage role mappings rather than using role mapping files.
        # The get role mappings API cannot retrieve role mappings that are defined in role mapping files.
        #
        # @option arguments [String, Array<String>] :name The distinct name that identifies the role mapping. The name is used solely as an identifier to facilitate interaction via the API; it does not affect the behavior of the mapping in any way. You can specify multiple mapping names as a comma-separated list. If you do not specify this parameter, the API returns information about all role mappings.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-role-mapping
        #
        def get_role_mapping(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_role_mapping' }

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
                     "_security/role_mapping/#{Utils.listify(_name)}"
                   else
                     '_security/role_mapping'
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
