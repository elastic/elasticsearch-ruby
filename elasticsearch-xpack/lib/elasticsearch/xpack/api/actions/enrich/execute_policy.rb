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

module Elasticsearch
  module XPack
    module API
      module Enrich
        module Actions
          # Creates the enrich index for an existing enrich policy.
          #
          # @option arguments [String] :name The name of the enrich policy
          # @option arguments [Boolean] :wait_for_completion Should the request should block until the execution is complete.
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/execute-enrich-policy-api.html
          #
          def execute_policy(arguments = {})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _name = arguments.delete(:name)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_enrich/policy/#{Elasticsearch::API::Utils.__listify(_name)}/_execute"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:execute_policy, [
            :wait_for_completion
          ].freeze)
      end
    end
    end
  end
end
