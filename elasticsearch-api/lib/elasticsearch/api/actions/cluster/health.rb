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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
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
        # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and index aliases that limit the request.
        #  Wildcard expressions (`*`) are supported.
        #  To target all data streams and indices in a cluster, omit this parameter or use _all or `*`.
        # @option arguments [String, Array<String>] :expand_wildcards Expand wildcard expression to concrete indices that are open, closed or both. Server default: all.
        # @option arguments [String] :level Return health information at a specific level of detail. Server default: cluster.
        # @option arguments [Boolean] :local If true, retrieve information from the local node only.
        #  If false, retrieve information from the master node.
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout The period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards Wait for the specified number of active shards.
        #  Use `all` to wait for all shards in the cluster to be active.
        #  Use `0` to not wait. Server default: 0.
        # @option arguments [String] :wait_for_events Wait until all currently queued events with the given priority are processed.
        # @option arguments [String, Integer] :wait_for_nodes Wait until the specified number (N) of nodes is available.
        #  It also accepts `>=N`, `<=N`, `>N` and `<N`.
        #  Alternatively, use the notations `ge(N)`, `le(N)`, `gt(N)`, and `lt(N)`.
        # @option arguments [Boolean] :wait_for_no_initializing_shards Wait (until the timeout expires) for the cluster to have no shard initializations.
        #  If false, the request does not wait for initializing shards.
        # @option arguments [Boolean] :wait_for_no_relocating_shards Wait (until the timeout expires) for the cluster to have no shard relocations.
        #  If false, the request not wait for relocating shards.
        # @option arguments [String] :wait_for_status Wait (until the timeout expires) for the cluster to reach a specific health status (or a better status).
        #  A green status is better than yellow and yellow is better than red.
        #  By default, the request does not wait for a particular status.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
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
