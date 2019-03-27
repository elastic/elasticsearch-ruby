module Elasticsearch
  module API
    module Cat
      module Actions

        # Display a terse version of the {Elasticsearch::API::Cluster::Actions#health} API output
        #
        # @example Display cluster health
        #
        #     puts client.cat.health
        #
        # @example Display header names in the output
        #
        #     puts client.cat.health v: true
        #
        # @example Return the information as Ruby objects
        #
        #     client.cat.health format: 'json'
        #
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :ts Set to false to disable timestamping
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-health.html
        #
        def health(arguments={})
          method = HTTP_GET
          path   = "_cat/health"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:health, [
            :format,
            :local,
            :master_timeout,
            :h,
            :help,
            :s,
            :ts,
            :v ].freeze)
      end
    end
  end
end
