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
        # Returns basic information about the health of the cluster.
        #
        # @option arguments [List] :index Limit the information returned to a specific index
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [String] :level Specify the level of detail for returned information (options: cluster, indices, shards)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [String] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [String] :wait_for_nodes Wait until the specified number of nodes is available
        # @option arguments [String] :wait_for_events Wait until all currently queued events with the given priority are processed (options: immediate, urgent, high, normal, low, languid)
        # @option arguments [Boolean] :wait_for_no_relocating_shards Whether to wait until there are no relocating shards in the cluster
        # @option arguments [Boolean] :wait_for_no_initializing_shards Whether to wait until there are no initializing shards in the cluster
        # @option arguments [String] :wait_for_status Wait until cluster is in a specific state (options: green, yellow, red)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/cluster-health.html
        #
        def health(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.health' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "_cluster/health/#{Utils.__listify(_index)}"
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
