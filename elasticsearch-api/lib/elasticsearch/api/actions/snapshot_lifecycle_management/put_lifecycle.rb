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
  module API
    module SnapshotLifecycleManagement
      module Actions
        # Creates or updates a snapshot lifecycle policy.
        #
        # @option arguments [String] :policy_id The id of the snapshot lifecycle policy
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The snapshot lifecycle policy definition to register
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.2/slm-api-put-policy.html
        #
        def put_lifecycle(arguments = {})
          raise ArgumentError, "Required argument 'policy_id' missing" unless arguments[:policy_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _policy_id = arguments.delete(:policy_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_slm/policy/#{Utils.__listify(_policy_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
