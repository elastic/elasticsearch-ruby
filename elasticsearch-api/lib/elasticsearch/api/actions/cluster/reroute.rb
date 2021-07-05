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
    module Cluster
      module Actions
        # Allows to manually change the allocation of individual shards in the cluster.
        #
        # @option arguments [Boolean] :dry_run Simulate the operation only and return the resulting state
        # @option arguments [Boolean] :explain Return an explanation of why the commands can or cannot be executed
        # @option arguments [Boolean] :retry_failed Retries allocation of shards that are blocked due to too many subsequent allocation failures
        # @option arguments [List] :metric Limit the information returned to the specified metrics. Defaults to all but metadata (options: _all, blocks, metadata, nodes, routing_table, master_node, version)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The definition of `commands` to perform (`move`, `cancel`, `allocate`)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.14/cluster-reroute.html
        #
        def reroute(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_POST
          path   = "_cluster/reroute"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body] || {}
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:reroute, [
          :dry_run,
          :explain,
          :retry_failed,
          :metric,
          :master_timeout,
          :timeout
        ].freeze)
      end
    end
  end
end
