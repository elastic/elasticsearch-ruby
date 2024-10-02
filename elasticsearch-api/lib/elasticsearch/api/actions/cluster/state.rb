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
        # Returns a comprehensive information about the state of the cluster.
        #
        # @option arguments [List] :metric Limit the information returned to the specified metrics (options: _all, blocks, metadata, nodes, routing_table, routing_nodes, master_node, version)
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Number] :wait_for_metadata_version Wait for the metadata version to be equal or greater than the specified metadata version
        # @option arguments [Time] :wait_for_timeout The maximum time to wait for wait_for_metadata_version before timing out
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/cluster-state.html
        #
        def state(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.state' }

          defined_params = %i[metric index].each_with_object({}) do |variable, set_variables|
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
                     "_cluster/state/#{Utils.__listify(_metric)}/#{Utils.__listify(_index)}"
                   elsif _metric
                     "_cluster/state/#{Utils.__listify(_metric)}"
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
