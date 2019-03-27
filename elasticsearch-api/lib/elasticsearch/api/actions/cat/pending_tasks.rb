module Elasticsearch
  module API
    module Cat
      module Actions

        # Display the information from the {Cluster::Actions#pending_tasks} API in a tabular format
        #
        # @example
        #
        #     puts client.cat.pending_tasks
        #
        # @example Display header names in the output
        #
        #     puts client.cat.pending_tasks v: true
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.pending_tasks format: 'json'
        #
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-pending-tasks.html
        #
        def pending_tasks(arguments={})
          method = HTTP_GET
          path   = "_cat/pending_tasks"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:pending_tasks, [
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
