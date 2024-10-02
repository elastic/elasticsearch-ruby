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
        # Creates a service account token for access without requiring basic authentication.
        #
        # @option arguments [String] :namespace An identifier for the namespace
        # @option arguments [String] :service An identifier for the service name
        # @option arguments [String] :name An identifier for the token name
        # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` (the default) then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes. (options: true, false, wait_for)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/security-api-create-service-token.html
        #
        def create_service_token(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.create_service_token' }

          defined_params = %i[namespace service name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'namespace' missing" unless arguments[:namespace]
          raise ArgumentError, "Required argument 'service' missing" unless arguments[:service]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _namespace = arguments.delete(:namespace)

          _service = arguments.delete(:service)

          _name = arguments.delete(:name)

          method = _name ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST
          path   = if _namespace && _service && _name
                     "_security/service/#{Utils.__listify(_namespace)}/#{Utils.__listify(_service)}/credential/token/#{Utils.__listify(_name)}"
                   else
                     "_security/service/#{Utils.__listify(_namespace)}/#{Utils.__listify(_service)}/credential/token"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
