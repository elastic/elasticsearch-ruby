module Elasticsearch
  module API
    module Cat
      module Actions

        # Return shard allocation information
        #
        # @example Display allocation for all nodes in the cluster
        #
        #     puts client.cat.allocation
        #
        # @example Display allocation for node with name 'node-1'
        #
        #     puts client.cat.allocation node_id: 'node-1'
        #
        # @example Display header names in the output
        #
        #     puts client.cat.allocation v: true
        #
        # @example Display only specific columns in the output (see the `help` parameter)
        #
        #     puts client.cat.allocation h: ['node', 'shards', 'disk.percent']
        #
        # @example Display only specific columns in the output, using the short names
        #
        #     puts client.cat.allocation h: 'n,s,dp'
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.allocation format: 'json'
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-allocation.html
        #
        def allocation(arguments={})
          node_id = arguments.delete(:node_id)
          method = HTTP_GET
          path   = Utils.__pathify '_cat/allocation', Utils.__listify(node_id)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]
          body   = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:allocation, [
            :format,
            :bytes,
            :local,
            :master_timeout,
            :h,
            :help,
            :s,
            :v ].freeze)
      end
    end
  end
end
