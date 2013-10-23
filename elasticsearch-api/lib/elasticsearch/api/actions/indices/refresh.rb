module Elasticsearch
  module API
    module Indices
      module Actions

        # Refresh the index and to make the changes (creates, updates, deletes) searchable.
        #
        # By default, Elasticsearch has a delay of 1 second until changes to an index are
        # available for search; the delay is configurable, see {Indices::Actions#put_settings}.
        #
        # You can trigger this operation explicitely, for example when performing a sequence of commands
        # in integration tests, or when you need to perform a manual "synchronization" of the index
        # with an external system at given moment.
        #
        # @example Refresh an index named _myindex_
        #
        #     client.indices.refresh index: 'myindex'
        #
        # @note The refresh operation can adversely affect indexing throughput when used too frequently.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                 to perform the operation on all indices
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-refresh/
        #
        def refresh(arguments={})
          valid_params = [ :ignore_indices ]

          method = 'POST'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_refresh'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
