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
        # Create SAML service provider metadata.
        # Generate SAML metadata for a SAML 2.0 Service Provider.
        # The SAML 2.0 specification provides a mechanism for Service Providers to describe their capabilities and configuration using a metadata file.
        # This API generates Service Provider metadata based on the configuration of a SAML realm in Elasticsearch.
        #
        # @option arguments [String] :realm_name The name of the SAML realm in Elasticsearch. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-saml-service-provider-metadata
        #
        def saml_service_provider_metadata(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.saml_service_provider_metadata' }

          defined_params = [:realm_name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'realm_name' missing" unless arguments[:realm_name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _realm_name = arguments.delete(:realm_name)

          method = Elasticsearch::API::HTTP_GET
          path   = "_security/saml/metadata/#{Utils.listify(_realm_name)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
