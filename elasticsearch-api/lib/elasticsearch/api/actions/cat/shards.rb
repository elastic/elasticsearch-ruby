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
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, m, g)
        # @option arguments [List] :h Comma-separated list of column names to display -- see the `help` argument
        # @option arguments [Boolean] :v Display column headers as part of the output
        # @option arguments [String] :format The output format. Options: 'text', 'json'; default: 'text'
        # @option arguments [Boolean] :help Return information about headers
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/cat-shards.html
        #
        def shards(arguments={})
          valid_params = [
            :local,
            :master_timeout,
            :h,
            :help,
            :v ]

          index = arguments.delete(:index)

          method = HTTP_GET

          path   = Utils.__pathify '_cat/shards', Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, valid_params
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
