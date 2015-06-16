module Elasticsearch
  module API
    module Snapshot
      module Actions

        VALID_GET_PARAMS = [ :master_timeout ].freeze

        # Return information about specific (or all) snapshots
        #
        # @example Return information about the `snapshot-2` snapshot
        #
        #     client.snapshot.get repository: 'my-backup', snapshot: 'snapshot-2'
        #
        # @example Return information about multiple snapshots
        #
        #     client.snapshot.get repository: 'my-backup', snapshot: ['snapshot-2', 'snapshot-3']
        #
        # @example Return information about all snapshots in the repository
        #
        #     client.snapshot.get repository: 'my-backup', snapshot: '_all'
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [List] :snapshot A comma-separated list of snapshot names (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def get(arguments={})
          get_request_for(arguments).body
        end

        def get_request_for(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing"   unless arguments[:snapshot]

          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_GET
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__listify(snapshot) )

          params = Utils.__validate_and_extract_params arguments, VALID_GET_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
