module Elasticsearch
  module API
    module Cat
      module Actions

        # Display information about cluster topology and nodes statistics
        #
        # @example Display basic information about nodes in the cluster (host, node name, memory usage, master, etc.)
        #
        #     puts client.cat.nodes
        #
        # @example Display header names in the output
        #
        #     puts client.cat.nodes v: true
        #
        # @example Display only specific columns in the output (see the `help` parameter)
        #
        #     puts client.cat.nodes h: %w(name version jdk disk.avail heap.percent load merges.total_time), v: true
        #
        # @example Display only specific columns in the output, using the short names
        #
        #     puts client.cat.nodes h: 'n,v,j,d,hp,l,mtt', v: true
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.nodes format: 'json'
        #
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :full_id Return the full node ID instead of the shortened version (default: false)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-nodes.html
        #
        def nodes(arguments={})
          method = HTTP_GET
          path   = "_cat/nodes"

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h], :escape => false) if params[:h]

          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:nodes, [
            :format,
            :full_id,
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
