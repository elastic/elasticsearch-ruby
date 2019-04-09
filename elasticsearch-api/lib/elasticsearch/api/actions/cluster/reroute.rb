# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

        # Perform manual shard allocation in the cluster.
        #
        # Pass the operations you want to perform in the `:body` option. Use the `dry_run` option to
        # evaluate the result of operations without actually performing them.
        #
        # @example Move shard `0` of index `myindex` from node named _Node1_ to node named _Node2_
        #
        #     client.cluster.reroute body: {
        #       commands: [
        #         { move: { index: 'myindex', shard: 0, from_node: 'Node1', to_node: 'Node2' } }
        #       ]
        #     }
        #
        # @note If you want to explicitly set the shard allocation to a certain node, you might
        #       want to look at the `allocation.*` cluster settings.
        #
        # @option arguments [Hash] :body The definition of `commands` to perform (`move`, `cancel`, `allocate`)
        # @option arguments [Boolean] :dry_run Simulate the operation only and return the resulting state
        # @option arguments [Boolean] :explain Return an explanation for why the commands can or cannot be executed
        # @option arguments [Boolean] :metric Limit the information returned to the specified metrics.
        #                                     Defaults to all but metadata. (Options: _all, blocks, metadata,
        #                                     nodes, routing_table, master_node, version)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :retry_failed Retries allocation of shards that are blocked due to too many
        #                                           subsequent allocation failures
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-reroute/
        #
        def reroute(arguments={})
          method = HTTP_POST
          path   = "_cluster/reroute"

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body] || {}

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:reroute, [
            :dry_run,
            :explain,
            :retry_failed,
            :metric,
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
