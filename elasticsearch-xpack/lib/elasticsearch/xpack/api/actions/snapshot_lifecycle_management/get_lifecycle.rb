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
      module SnapshotLifecycleManagement
        module Actions
          # Retrieves one or more snapshot lifecycle policy definitions and information about the latest snapshot attempts.
          #
          # @option arguments [List] :policy_id Comma-separated list of snapshot lifecycle policies to retrieve
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/slm-api-get-policy.html
          #
          def get_lifecycle(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _policy_id = arguments.delete(:policy_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _policy_id
                       "_slm/policy/#{Elasticsearch::API::Utils.__listify(_policy_id)}"
                     else
                       "_slm/policy"
                     end
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
        end
      end
    end
  end
end
