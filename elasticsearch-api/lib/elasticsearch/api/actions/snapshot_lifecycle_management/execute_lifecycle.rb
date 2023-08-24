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
    module SnapshotLifecycleManagement
      module Actions
        # Immediately creates a snapshot according to the lifecycle policy, without waiting for the scheduled time.
        #
        # @option arguments [String] :policy_id The id of the snapshot lifecycle policy to be executed
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/slm-api-execute-lifecycle.html
        #
        def execute_lifecycle(arguments = {})
          raise ArgumentError, "Required argument 'policy_id' missing" unless arguments[:policy_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _policy_id = arguments.delete(:policy_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_slm/policy/#{Utils.__listify(_policy_id)}/_execute"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
