module Elasticsearch
  module API
    module Cat
      module Actions

        # Display shard allocation across nodes
        #
        # @example Display information for all indices
        #
        #     puts client.cat.shards
        #
        # @example Display information for a specific index
        #
        #     puts client.cat.shards index: 'index-a'
        #
        # @example Display information for a list of indices
        #
        #     puts client.cat.shards index: ['index-a', 'index-b']
        #
        # @example Display header names in the output
        #
        #     puts client.cat.shards v: true
        #
        # @example Display shard size in choice of units
        #
        #     puts client.cat.shards bytes: 'b'
        #
        # @example Display only specific columns in the output (see the `help` parameter)
        #
        #     puts client.cat.shards h: ['node', 'index', 'shard', 'prirep', 'docs', 'store', 'merges.total']
        #
        # @example Display only specific columns in the output, using the short names
        #
        #     puts client.cat.shards h: 'n,i,s,p,d,sto,mt'
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.shards format: 'json'
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-shards.html
        #
        def shards(arguments={})
          index = arguments.delete(:index)
          method = HTTP_GET
          path   = Utils.__pathify '_cat/shards', Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:shards, [
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
