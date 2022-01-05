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
        # Returns information about hot threads on each node in the cluster.
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [Time] :interval The interval for the second sampling of threads
        # @option arguments [Number] :snapshots Number of samples of thread stacktrace (default: 10)
        # @option arguments [Number] :threads Specify the number of threads to provide information for (default: 3)
        # @option arguments [Boolean] :ignore_idle_threads Don't show threads that are in known-idle places, such as waiting on a socket select or pulling from an empty task queue (default: true)
        # @option arguments [String] :type The type to sample (default: cpu) (options: cpu, wait, block, mem)
        # @option arguments [String] :sort The sort order for 'cpu' type (default: total) (options: cpu, total)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # *Deprecation notice*:
        # The hot accepts /_cluster/nodes as prefix for backwards compatibility reasons
        # Deprecated since version 7.0.0
        #
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/cluster-nodes-hot-threads.html
        #
        def hot_threads(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _node_id = arguments.delete(:node_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _node_id
                     "_cluster/nodes/#{Utils.__listify(_node_id)}/hot_threads"
                   else
                     "_cluster/nodes/hot_threads"
                   end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:hot_threads, [
          :interval,
          :snapshots,
          :threads,
          :ignore_idle_threads,
          :type,
          :sort,
          :timeout
        ].freeze)
      end
    end
  end
end
