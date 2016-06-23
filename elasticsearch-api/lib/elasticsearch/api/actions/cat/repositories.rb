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
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-repositories.html
        #
        def repositories(arguments={})
          valid_params = [
            :master_timeout,
            :h,
            :help,
            :v ]

          unsupported_params = [ :format ]
          Utils.__report_unsupported_parameters(arguments.keys, unsupported_params)

          method = HTTP_GET
          path   = "_cat/repositories"
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
