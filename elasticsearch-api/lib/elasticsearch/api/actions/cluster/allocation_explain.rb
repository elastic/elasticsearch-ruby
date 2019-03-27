module Elasticsearch
  module API
    module Cluster
      module Actions

        # Return the information about why a shard is or isn't allocated
        #
        # @option arguments [Hash] :body The index, shard, and primary flag to explain. Empty means 'explain the first unassigned shard'
        # @option arguments [Boolean] :include_yes_decisions Return 'YES' decisions in explanation (default: false)
        # @option arguments [Boolean] :include_disk_info Return information about disk usage and shard sizes (default: false)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-allocation-explain.html
        #
        def allocation_explain(arguments={})
          method = 'GET'
          path   = "_cluster/allocation/explain"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:allocation_explain, [
            :include_yes_decisions,
            :include_disk_info ].freeze)
      end
    end
  end
end
