module Elasticsearch
  module API
    module Cat
      module Actions

        # Display basic information about the master node
        #
        # @example
        #
        #     puts client.cat.master
        #
        # @example Display header names in the output
        #
        #     puts client.cat.master v: true
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.master format: 'json'
        #
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-master.html
        #
        def master(arguments={})
          method = HTTP_GET
          path   = "_cat/master"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:master, [
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
