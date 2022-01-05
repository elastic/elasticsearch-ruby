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

module Elasticsearch
  module API
    module Cluster
      module Actions
        # Provides explanations for shard allocations in the cluster.
        #
        # @option arguments [Boolean] :include_yes_decisions Return 'YES' decisions in explanation (default: false)
        # @option arguments [Boolean] :include_disk_info Return information about disk usage and shard sizes (default: false)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The index, shard, and primary flag to explain. Empty means 'explain a randomly-chosen unassigned shard'
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/cluster-allocation-explain.html
        #
        def allocation_explain(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          method = if arguments[:body]
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = "_cluster/allocation/explain"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:allocation_explain, [
          :include_yes_decisions,
          :include_disk_info
        ].freeze)
      end
    end
  end
end
