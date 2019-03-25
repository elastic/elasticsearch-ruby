module Elasticsearch
  module API
    module Cat
      module Actions

        # Shows all snapshots that belong to a specific repository
        #
        # @example Return snapshots for 'my_repository'
        #
        #     client.cat.snapshots repository: 'my_repository'
        #
        # @example Return id, status and start_epoch for 'my_repository'
        #
        #     client.cat.snapshots repository: 'my_repository', h: 'id,status,start_epoch'
        #
        # @option arguments [List] :repository Name of repository from which to fetch the snapshot information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :ignore_unavailable Set to true to ignore unavailable snapshots
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-snapshots.html
        #
        def snapshots(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" if !arguments[:repository] && !arguments[:help]
          repository = arguments.delete(:repository)

          method = HTTP_GET
          path   = Utils.__pathify "_cat/snapshots", Utils.__escape(repository)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:snapshots, [
            :format,
            :ignore_unavailable,
            :master_timeout,
            :h,
            :help,
            :s,
            :v ].freeze)
      end
    end
  end
end
