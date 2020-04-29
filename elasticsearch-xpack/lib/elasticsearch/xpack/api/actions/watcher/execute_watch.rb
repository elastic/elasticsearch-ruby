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
      module Watcher
        module Actions
          # Forces the execution of a stored watch.
          #
          # @option arguments [String] :id Watch ID
          # @option arguments [Boolean] :debug indicates whether the watch should execute in debug mode
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Execution control
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-execute-watch.html
          #
          def execute_watch(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_PUT
            path   = if _id
                       "_watcher/watch/#{Elasticsearch::API::Utils.__listify(_id)}/_execute"
                     else
                       "_watcher/watch/_execute"
            end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:execute_watch, [
            :debug
          ].freeze)
      end
    end
    end
  end
end
