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

        # Returns information about cluster "health".
        #
        # @example Get the cluster health information
        #
        #     client.cluster.health
        #
        # @example Block the request until the cluster is in the "yellow" state
        #
        #     client.cluster.health wait_for_status: 'yellow'
        #
        # @option arguments [String] :index Limit the information returned to a specific index
        # @option arguments [String] :level Specify the level of detail for returned information
        #                                   (options: cluster, indices, shards)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Number] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [Number] :wait_for_nodes Wait until the specified number of nodes is available
        # @option arguments [Number] :wait_for_relocating_shards Wait until the specified number of relocating
        #                                                        shards is finished
        # @option arguments [Boolean] :wait_for_no_relocating_shards Whether to wait until there are no relocating
        #                                                            shards in the cluster
        # @option arguments [Boolean] :wait_for_no_initializing_shards Whether to wait until there are no
        #                                                              initializing shards in the cluster
        # @option arguments [String] :wait_for_status Wait until cluster is in a specific state
        #                                             (options: green, yellow, red)
        # @option arguments [List] :wait_for_events Wait until all currently queued events with the given priorty
        #                                           are processed (immediate, urgent, high, normal, low, languid)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-health/
        #
        def health(arguments={})
          arguments = arguments.clone
          index     = arguments.delete(:index)
          method = HTTP_GET
          path   = Utils.__pathify "_cluster/health", Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:health, [
            :expand_wildcards,
            :level,
            :local,
            :master_timeout,
            :timeout,
            :wait_for_active_shards,
            :wait_for_nodes,
            :wait_for_events,
            :wait_for_no_relocating_shards,
            :wait_for_no_initializing_shards,
            :wait_for_status ].freeze)
      end
    end
  end
end
