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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Cluster
      module Actions
        # Get the cluster health status.
        # You can also use the API to get the health status of only specified data streams and indices.
        # For data streams, the API retrieves the health status of the stream’s backing indices.
        # The cluster health status is: green, yellow or red.
        # On the shard level, a red status indicates that the specific shard is not allocated in the cluster. Yellow means that the primary shard is allocated but replicas are not. Green means that all shards are allocated.
        # The index level status is controlled by the worst shard status.
        # One of the main benefits of the API is the ability to wait until the cluster reaches a certain high watermark health level.
        # The cluster status is controlled by the worst index status.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and index aliases used to limit the request. Wildcard expressions (+*+) are supported. To target all data streams and indices in a cluster, omit this parameter or use _all or +*+.
        # @option arguments [String, Array<String>] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        # @option arguments [String] :level Can be one of cluster, indices or shards. Controls the details level of the health information returned. Server default: cluster.
        # @option arguments [Boolean] :local If true, the request retrieves information from the local node only. Defaults to false, which means information is retrieved from the master node.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards A number controlling to how many active shards to wait for, all to wait for all shards in the cluster to be active, or 0 to not wait. Server default: 0.
        # @option arguments [String] :wait_for_events Can be one of immediate, urgent, high, normal, low, languid. Wait until all currently queued events with the given priority are processed.
        # @option arguments [String, Integer] :wait_for_nodes The request waits until the specified number N of nodes is available. It also accepts >=N, <=N, >N and <N. Alternatively, it is possible to use ge(N), le(N), gt(N) and lt(N) notation.
        # @option arguments [Boolean] :wait_for_no_initializing_shards A boolean value which controls whether to wait (until the timeout provided) for the cluster to have no shard initializations. Defaults to false, which means it will not wait for initializing shards.
        # @option arguments [Boolean] :wait_for_no_relocating_shards A boolean value which controls whether to wait (until the timeout provided) for the cluster to have no shard relocations. Defaults to false, which means it will not wait for relocating shards.
        # @option arguments [String] :wait_for_status One of green, yellow or red. Will wait (until the timeout provided) until the status of the cluster changes to the one provided or better, i.e. green > yellow > red. By default, will not wait for any status.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health
        #
        def health(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.health' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "_cluster/health/#{Utils.listify(_index)}"
                   else
                     '_cluster/health'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
