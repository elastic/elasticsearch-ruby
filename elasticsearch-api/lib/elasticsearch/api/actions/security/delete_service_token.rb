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
        # Delete service account tokens.
        # Delete service account tokens for a service in a specified namespace.
        #
        # @option arguments [String] :namespace The namespace, which is a top-level grouping of service accounts. (*Required*)
        # @option arguments [String] :service The service name. (*Required*)
        # @option arguments [String] :name The name of the service account token. (*Required*)
        # @option arguments [String] :refresh If +true+ then refresh the affected shards to make this operation visible to search, if +wait_for+ (the default) then wait for a refresh to make this operation visible to search, if +false+ then do nothing with refreshes.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-delete-service-token
        #
        def delete_service_token(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.delete_service_token' }

          defined_params = [:namespace, :service, :name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'namespace' missing" unless arguments[:namespace]
          raise ArgumentError, "Required argument 'service' missing" unless arguments[:service]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _namespace = arguments.delete(:namespace)

          _service = arguments.delete(:service)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_security/service/#{Utils.listify(_namespace)}/#{Utils.listify(_service)}/credential/token/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
