module Elasticsearch
  module API
    module Cluster
      module Actions

        # Return the information about why a shard is or isn't allocated
        #
        # @option arguments [Hash] :body The index, shard, and primary flag to explain. Empty means 'explain the first unassigned shard'
        # @option arguments [Boolean] :include_yes_decisions Return 'YES' decisions in explanation (default: false)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/cluster-allocation-explain.html
        #
        def allocation_explain(arguments={})
          Utils.__report_unsupported_method(__method__)

          valid_params = [ :include_yes_decisions ]

          method = HTTP_GET
          path   = "_cluster/allocation/explain"
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
