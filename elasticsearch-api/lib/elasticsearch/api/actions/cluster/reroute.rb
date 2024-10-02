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
    module Cluster
      module Actions
        # Allows to manually change the allocation of individual shards in the cluster.
        #
        # @option arguments [Boolean] :dry_run Simulate the operation only and return the resulting state
        # @option arguments [Boolean] :explain Return an explanation of why the commands can or cannot be executed
        # @option arguments [Boolean] :retry_failed Retries allocation of shards that are blocked due to too many subsequent allocation failures
        # @option arguments [List] :metric Limit the information returned to the specified metrics. Defaults to all but metadata (options: _all, blocks, metadata, nodes, none, routing_table, master_node, version)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The definition of `commands` to perform (`move`, `cancel`, `allocate`)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/cluster-reroute.html
        #
        def reroute(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.reroute' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body) || {}

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
