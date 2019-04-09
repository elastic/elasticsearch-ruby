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

        # Get information about the cluster state (indices settings, allocations, etc)
        #
        # @example
        #
        #     client.cluster.state
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or omit to
        #                                 perform the operation on all indices
        # @option arguments [List] :metric Limit the information returned to the specified metrics
        #                                 (options: _all, blocks, index_templates, metadata, nodes, routing_table,
        #                                  master_node, version)
        # @option arguments [List] :index_templates A comma separated list to return specific index templates when
        #                                           returning metadata
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression for inidices
        #                                              (options: open, closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-state/
        #
        def state(arguments={})
          arguments = arguments.clone
          index     = arguments.delete(:index)
          metric    = arguments.delete(:metric)
          method = HTTP_GET
          path   = Utils.__pathify '_cluster/state',
                                   Utils.__listify(metric),
                                   Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          [:index_templates].each do |key|
            params[key] = Utils.__listify(params[key]) if params[key]
          end

          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:state, [
            :local,
            :master_timeout,
            :flat_settings,
            :wait_for_metadata_version,
            :wait_for_timeout,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards ].freeze)
      end
    end
  end
end
