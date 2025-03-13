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
        # Get the cluster state.
        # Get comprehensive information about the state of the cluster.
        # The cluster state is an internal data structure which keeps track of a variety of information needed by every node, including the identity and attributes of the other nodes in the cluster; cluster-wide settings; index metadata, including the mapping and settings for each index; the location and status of every shard copy in the cluster.
        # The elected master node ensures that every node in the cluster has a copy of the same cluster state.
        # This API lets you retrieve a representation of this internal state for debugging or diagnostic purposes.
        # You may need to consult the Elasticsearch source code to determine the precise meaning of the response.
        # By default the API will route requests to the elected master node since this node is the authoritative source of cluster states.
        # You can also retrieve the cluster state held on the node handling the API request by adding the +?local=true+ query parameter.
        # Elasticsearch may need to expend significant effort to compute a response to this API in larger clusters, and the response may comprise a very large quantity of data.
        # If you use this API repeatedly, your cluster may become unstable.
        # WARNING: The response is a representation of an internal data structure.
        # Its format is not subject to the same compatibility guarantees as other more stable APIs and may change from version to version.
        # Do not query this API using external monitoring tools.
        # Instead, obtain the information you require using other more stable cluster APIs.
        #
        # @option arguments [String, Array<String>] :metric Limit the information returned to the specified metrics
        # @option arguments [String, Array] :index A comma-separated list of index names; use +_all+ or empty string to perform the operation on all indices
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes +_all+ string or when no indices have been specified) Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master Server default: 30s.
        # @option arguments [Integer] :wait_for_metadata_version Wait for the metadata version to be equal or greater than the specified metadata version
        # @option arguments [Time] :wait_for_timeout The maximum time to wait for wait_for_metadata_version before timing out
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-state
        #
        def state(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.state' }

          defined_params = [:metric, :index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _metric = arguments.delete(:metric)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _metric && _index
                     "_cluster/state/#{Utils.listify(_metric)}/#{Utils.listify(_index)}"
                   elsif _metric
                     "_cluster/state/#{Utils.listify(_metric)}"
                   else
                     '_cluster/state'
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
