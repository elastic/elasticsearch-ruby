module Elasticsearch
  module API
    module Cat
      module Actions

        # Shows all repositories registered in a cluster
        #
        # @example Return list of repositories
        #
        #     client.cat.repositories
        #
        # @example Return only id for each repository
        #
        #     client.cat.repositories h: 'id'
        #
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-repositories.html
        #
        def repositories(arguments={})
          method = HTTP_GET
          path   = "_cat/repositories"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:repositories, [
            :master_timeout,
            :h,
            :help,
            :v,
            :s ].freeze)
      end
    end
  end
end
