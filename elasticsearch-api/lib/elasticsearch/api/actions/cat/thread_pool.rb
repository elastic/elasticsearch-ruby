module Elasticsearch
  module API
    module Cat
      module Actions

        # Display thread pool statistics across nodes (use the `help` parameter to display a list
        # of available thread pools)
        #
        # @example Display information about all thread pools across nodes
        #
        #     puts client.cat.thread_pool
        #
        # @example Display header names in the output
        #
        #     puts client.cat.thread_pool v: true
        #
        # @example Display information about the indexing thread pool
        #
        #     puts client.cat.thread_pool h: %w(h ip index.active index.size index.queue index.rejected), v: true
        #
        # @example Display information about the indexing and search threads, using the short names
        #
        #     puts client.cat.thread_pool h: 'host,ia,is,iq,ir,sa,ss,sq,sr', v: true
        #
        # @option arguments [List] :thread_pool_patterns A comma-separated list of regular-expressions to filter the thread pools in the output
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :size The multiplier in which to display values (options: , k, m, g, t, p)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-thread-pool.html
        #
        def thread_pool(arguments={})
          method = HTTP_GET
          path   = "_cat/thread_pool"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:thread_pool, [
            :format,
            :size,
            :local,
            :thread_pool_patterns,
            :master_timeout,
            :h,
            :help,
            :s,
            :v ].freeze)
      end
    end
  end
end
