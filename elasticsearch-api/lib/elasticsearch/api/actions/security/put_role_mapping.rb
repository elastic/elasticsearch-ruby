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
        # Create or update role mappings.
        # Role mappings define which roles are assigned to each user.
        # Each mapping has rules that identify users and a list of roles that are granted to those users.
        # The role mapping APIs are generally the preferred way to manage role mappings rather than using role mapping files. The create or update role mappings API cannot update role mappings that are defined in role mapping files.
        # NOTE: This API does not create roles. Rather, it maps users to existing roles.
        # Roles can be created by using the create or update roles API or roles files.
        # **Role templates**
        # The most common use for role mappings is to create a mapping from a known value on the user to a fixed role name.
        # For example, all users in the +cn=admin,dc=example,dc=com+ LDAP group should be given the superuser role in Elasticsearch.
        # The +roles+ field is used for this purpose.
        # For more complex needs, it is possible to use Mustache templates to dynamically determine the names of the roles that should be granted to the user.
        # The +role_templates+ field is used for this purpose.
        # NOTE: To use role templates successfully, the relevant scripting feature must be enabled.
        # Otherwise, all attempts to create a role mapping with role templates fail.
        # All of the user fields that are available in the role mapping rules are also available in the role templates.
        # Thus it is possible to assign a user to a role that reflects their username, their groups, or the name of the realm to which they authenticated.
        # By default a template is evaluated to produce a single string that is the name of the role which should be assigned to the user.
        # If the format of the template is set to "json" then the template is expected to produce a JSON string or an array of JSON strings for the role names.
        #
        # @option arguments [String] :name The distinct name that identifies the role mapping.
        #  The name is used solely as an identifier to facilitate interaction via the API; it does not affect the behavior of the mapping in any way. (*Required*)
        # @option arguments [String] :refresh If +true+ (the default) then refresh the affected shards to make this operation visible to search, if +wait_for+ then wait for a refresh to make this operation visible to search, if +false+ then do nothing with refreshes.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-role-mapping
        #
        def put_role_mapping(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.put_role_mapping' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_security/role_mapping/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
