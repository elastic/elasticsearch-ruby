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
        # Reroute the cluster.
        # Manually change the allocation of individual shards in the cluster.
        # For example, a shard can be moved from one node to another explicitly, an allocation can be canceled, and an unassigned shard can be explicitly allocated to a specific node.
        # It is important to note that after processing any reroute commands Elasticsearch will perform rebalancing as normal (respecting the values of settings such as +cluster.routing.rebalance.enable+) in order to remain in a balanced state.
        # For example, if the requested allocation includes moving a shard from node1 to node2 then this may cause a shard to be moved from node2 back to node1 to even things out.
        # The cluster can be set to disable allocations using the +cluster.routing.allocation.enable+ setting.
        # If allocations are disabled then the only allocations that will be performed are explicit ones given using the reroute command, and consequent allocations due to rebalancing.
        # The cluster will attempt to allocate a shard a maximum of +index.allocation.max_retries+ times in a row (defaults to +5+), before giving up and leaving the shard unallocated.
        # This scenario can be caused by structural problems such as having an analyzer which refers to a stopwords file which doesn’t exist on all nodes.
        # Once the problem has been corrected, allocation can be manually retried by calling the reroute API with the +?retry_failed+ URI query parameter, which will attempt a single retry round for these shards.
        #
        # @option arguments [Boolean] :dry_run If true, then the request simulates the operation.
        #  It will calculate the result of applying the commands to the current cluster state and return the resulting cluster state after the commands (and rebalancing) have been applied; it will not actually perform the requested changes.
        # @option arguments [Boolean] :explain If true, then the response contains an explanation of why the commands can or cannot run.
        # @option arguments [String, Array<String>] :metric Limits the information returned to the specified metrics. Server default: all.
        # @option arguments [Boolean] :retry_failed If true, then retries allocation of shards that are blocked due to too many subsequent allocation failures.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-reroute
        #
        def reroute(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.reroute' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_cluster/reroute'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
