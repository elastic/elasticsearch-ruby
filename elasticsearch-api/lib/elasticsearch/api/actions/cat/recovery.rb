module Elasticsearch
  module API
    module Cat
      module Actions

        # Display information about the recovery process (allocating shards)
        #
        # @example Display information for all indices
        #
        #     puts client.cat.recovery
        #
        # @example Display information for a specific index
        #
        #     puts client.cat.recovery index: 'index-a'
        #
        # @example Display information for indices matching a pattern
        #
        #     puts client.cat.recovery index: 'index-*'
        #
        # @example Display header names in the output
        #
        #     puts client.cat.recovery v: true
        #
        # @example Display only specific columns in the output (see the `help` parameter)
        #
        #     puts client.cat.recovery h: ['node', 'index', 'shard', 'percent']
        #
        # @example Display only specific columns in the output, using the short names
        #
        #     puts client.cat.recovery h: 'n,i,s,per'
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.recovery format: 'json'
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-recovery.html
        #
        def recovery(arguments={})
          index = arguments.delete(:index)

          method = HTTP_GET

          path   = Utils.__pathify '_cat/recovery', Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:recovery, [
            :format,
            :bytes,
            :master_timeout,
            :h,
            :help,
            :s,
            :v ].freeze)
      end
    end
  end
end
