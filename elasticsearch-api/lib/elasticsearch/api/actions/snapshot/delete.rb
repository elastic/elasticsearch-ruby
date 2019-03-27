module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Delete a snapshot from the repository
        #
        # @note Will also abort a currently running snapshot.
        #
        # @example Delete the `snapshot-1` snapshot
        #
        #     client.snapshot.delete repository: 'my-backups', snapshot: 'snapshot-1'
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [String] :snapshot A snapshot name (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
        #
        def delete(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing"   unless arguments[:snapshot]
          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_DELETE
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__listify(snapshot) )

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete, [
            :master_timeout ].freeze)
      end
    end
  end
end
