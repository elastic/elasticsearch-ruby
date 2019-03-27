module Elasticsearch
  module API
    module Cat
      module Actions

        # Returns information about aliases, including associated routing values and filters.
        #
        # @example Display all aliases in the cluster
        #
        #     puts client.cat.aliases
        #
        # @example Display indices for the 'year-2013' alias
        #
        #     puts client.cat.aliases name: 'year-2013'
        #
        # @example Display header names in the output
        #
        #     puts client.cat.aliases v: true
        #
        # @example Return only the 'alias' and 'index' columns
        #
        #     puts client.cat.aliases h: ['alias', 'index']
        #
        # @example Return only the 'alias' and 'index' columns, using short names
        #
        #     puts client.cat.aliases h: 'a,i'
        #
        # @example Return the output sorted by the alias name
        #
        #     puts client.cat.aliases s: 'alias'
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.aliases format: 'json'
        #
        # @option arguments [List] :name A comma-separated list of alias names to return
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-aliases.html
        #
        def aliases(arguments={})
          name = arguments.delete(:name)
          method = HTTP_GET
          path   = Utils.__pathify '_cat/aliases', Utils.__listify(name)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]
          body   = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:aliases, [
            :format,
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
