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

        # Returns information about nodes in the cluster (cluster settings, JVM version, etc).
        #
        # Use the `all` option to return all available settings, or limit the information returned
        # to a specific type (eg. `http`).
        #
        # Use the `node_id` option to limit information to specific node(s).
        #
        # @example Return information about JVM
        #
        #     client.nodes.info jvm: true
        #
        # @example Return information about HTTP and network
        #
        #     client.nodes.info http: true, network: true
        #
        # @example Pass a list of metrics
        #
        #     client.nodes.info metric: ['http', 'network']
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information;
        #                                   use `_local` to return information from the node you're connecting to, leave
        #                                   empty to get information from all nodes
        # @option arguments [Boolean] :_all Return all available information
        # @option arguments [Boolean] :http Return information about HTTP
        # @option arguments [Boolean] :jvm Return information about the JVM
        # @option arguments [Boolean] :network Return information about network
        # @option arguments [Boolean] :os Return information about the operating system
        # @option arguments [Boolean] :plugins Return information about plugins
        # @option arguments [Boolean] :process Return information about the Elasticsearch process
        # @option arguments [Boolean] :settings Return information about node settings
        # @option arguments [Boolean] :thread_pool Return information about the thread pool
        # @option arguments [Boolean] :transport Return information about transport
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-nodes-info/
        #
        def info(arguments={})
          arguments = arguments.clone
          metric    = arguments.delete(:metric)
          method = HTTP_GET
          if metric
            parts = metric
          else
            parts = Utils.__extract_parts arguments, ParamsRegistry.get(:info_parts)
          end

          path   = Utils.__pathify '_nodes', Utils.__listify(arguments[:node_id]), Utils.__listify(parts)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(:info_params)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:info_params, [ :flat_settings, :timeout ].freeze)

        # Register this action with its valid parts when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:info_parts, [
            :_all,
            :http,
            :jvm,
            :network,
            :os,
            :plugins,
            :process,
            :settings,
            :thread_pool,
            :transport,
            :timeout ].freeze)
      end
    end
  end
end
