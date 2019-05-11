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
    module Nodes
      module Actions

        # Returns information about the hottest threads in the cluster or on a specific node as a String.
        #
        #
        # The information is returned as text, and allows you to understand what are currently
        # the most taxing operations happening in the cluster, for debugging or monitoring purposes.
        #
        # @example Return 10 hottest threads
        #
        #     client.nodes.hot_threads threads: 10
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [Time] :interval The interval for the second sampling of threads
        # @option arguments [Number] :snapshots Number of samples of thread stacktrace (default: 10)
        # @option arguments [Number] :threads Specify the number of threads to provide information for (default: 3)
        # @option arguments [Boolean] :ignore_idle_threads Don't show threads that are in known-idle places, such as waiting on a socket select or pulling from an empty task queue (default: true)
        # @option arguments [String] :type The type to sample (default: cpu) (options: cpu, wait, block)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @return [String]
        #
        # @see https://www.elastic.co/guide/reference/api/admin-cluster-nodes-hot-threads/
        #
        def hot_threads(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify '_nodes', Utils.__listify(arguments[:node_id]), 'hot_threads'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:hot_threads, [
            :interval,
            :snapshots,
            :threads,
            :ignore_idle_threads,
            :type,
            :timeout ].freeze)
      end
    end
  end
end
