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
        # Update voting configuration exclusions.
        # Update the cluster voting config exclusions by node IDs or node names.
        # By default, if there are more than three master-eligible nodes in the cluster and you remove fewer than half of the master-eligible nodes in the cluster at once, the voting configuration automatically shrinks.
        # If you want to shrink the voting configuration to contain fewer than three nodes or to remove half or more of the master-eligible nodes in the cluster at once, use this API to remove departing nodes from the voting configuration manually.
        # The API adds an entry for each specified node to the cluster’s voting configuration exclusions list.
        # It then waits until the cluster has reconfigured its voting configuration to exclude the specified nodes.
        # Clusters should have no voting configuration exclusions in normal operation.
        # Once the excluded nodes have stopped, clear the voting configuration exclusions with +DELETE /_cluster/voting_config_exclusions+.
        # This API waits for the nodes to be fully removed from the cluster before it returns.
        # If your cluster has voting configuration exclusions for nodes that you no longer intend to remove, use +DELETE /_cluster/voting_config_exclusions?wait_for_removal=false+ to clear the voting configuration exclusions without waiting for the nodes to leave the cluster.
        # A response to +POST /_cluster/voting_config_exclusions+ with an HTTP status code of 200 OK guarantees that the node has been removed from the voting configuration and will not be reinstated until the voting configuration exclusions are cleared by calling +DELETE /_cluster/voting_config_exclusions+.
        # If the call to +POST /_cluster/voting_config_exclusions+ fails or returns a response with an HTTP status code other than 200 OK then the node may not have been removed from the voting configuration.
        # In that case, you may safely retry the call.
        # NOTE: Voting exclusions are required only when you remove at least half of the master-eligible nodes from a cluster in a short time period.
        # They are not required when removing master-ineligible nodes or when removing fewer than half of the master-eligible nodes.
        #
        # @option arguments [String, Array<String>] :node_names A comma-separated list of the names of the nodes to exclude from the
        #  voting configuration. If specified, you may not also specify node_ids.
        # @option arguments [String, Array] :node_ids A comma-separated list of the persistent ids of the nodes to exclude
        #  from the voting configuration. If specified, you may not also specify node_names.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [Time] :timeout When adding a voting configuration exclusion, the API waits for the
        #  specified nodes to be excluded from the voting configuration before
        #  returning. If the timeout expires before the appropriate condition
        #  is satisfied, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-post-voting-config-exclusions
        #
        def post_voting_config_exclusions(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.post_voting_config_exclusions' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_cluster/voting_config_exclusions'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
