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
    module Nodes
      module Actions
        # Reloads secure settings.
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs to span the reload/reinit call. Should stay empty because reloading usually involves all cluster nodes.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body An object containing the password for the elasticsearch keystore
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/secure-settings.html#reloadable-secure-settings
        #
        def reload_secure_settings(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.reload_secure_settings' }

          defined_params = [:node_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _node_id = arguments.delete(:node_id)

          method = Elasticsearch::API::HTTP_POST
          path   = if _node_id
                     "_nodes/#{Utils.__listify(_node_id)}/reload_secure_settings"
                   else
                     '_nodes/reload_secure_settings'
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
