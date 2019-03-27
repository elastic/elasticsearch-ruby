module Elasticsearch
  module API
    module Cat
      module Actions

        # Return the most important statistics about indices, across the cluster nodes
        #
        # Use the `help` parameter to display available statistics.
        #
        # @example Display information for all indices
        #
        #     puts client.cat.indices
        #
        # @example Display information for a specific index
        #
        #     puts client.cat.indices index: 'index-a'
        #
        # @example Display information for indices matching a pattern
        #
        #     puts client.cat.indices index: 'index-*'
        #
        # @example Display header names in the output
        #
        #     puts client.cat.indices v: true
        #
        # @example Display only specific columns in the output (see the `help` parameter)
        #
        #     puts client.cat.indices h: ['index', 'docs.count', 'fielddata.memory_size', 'filter_cache.memory_size']
        #
        # @example Display only specific columns in the output, using the short names
        #
        #     puts client.cat.indices h: 'i,dc,ss,mt', v: true
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.indices format: 'json'
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, m, g)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [String] :health A health status ("green", "yellow", or "red" to filter only indices matching the specified health status (options: green, yellow, red)
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :pri Set to true to return stats only for primary shards
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-indices.html
        #
        def indices(arguments={})
          index = arguments.delete(:index)
          method = HTTP_GET

          path   = Utils.__pathify '_cat/indices', Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:indices, [
            :format,
            :bytes,
            :local,
            :master_timeout,
            :h,
            :health,
            :help,
            :pri,
            :s,
            :v ].freeze)
      end
    end
  end
end
