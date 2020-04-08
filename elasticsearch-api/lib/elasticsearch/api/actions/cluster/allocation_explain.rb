# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cluster
      module Actions
        # Provides explanations for shard allocations in the cluster.
        #
        # @option arguments [Boolean] :include_yes_decisions Return 'YES' decisions in explanation (default: false)
        # @option arguments [Boolean] :include_disk_info Return information about disk usage and shard sizes (default: false)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The index, shard, and primary flag to explain. Empty means 'explain the first unassigned shard'
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/cluster-allocation-explain.html
        #
        def allocation_explain(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_GET
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
