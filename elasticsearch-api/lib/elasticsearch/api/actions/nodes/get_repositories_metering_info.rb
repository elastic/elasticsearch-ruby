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
    module Nodes
      module Actions
        # Returns cluster repositories metering information.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/get-repositories-metering-api.html
        #
        def get_repositories_metering_info(arguments = {})
          raise ArgumentError, "Required argument 'node_id' missing" unless arguments[:node_id]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _node_id = arguments.delete(:node_id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_nodes/#{Utils.__listify(_node_id)}/_repositories_metering"
          params = {}

          body = nil
          perform_request(method, path, params, body, headers).body
        end
      end
    end
  end
end
