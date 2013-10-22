module Elasticsearch
  module API
    module Indices
      module Actions

        # "Flush" the index or indices.
        #
        # The "flush" operation clears the transaction log and memory and writes data to disk.
        # It corresponds to a Lucene "commit" operation.
        #
        # @note The flush operation is handled automatically by Elasticsearch, you don't need to perform it manually.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string for all indices
        # @option arguments [Boolean] :force TODO: ?
        # @option arguments [Boolean] :full TODO: ?
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        # @option arguments [Boolean] :refresh Refresh the index after performing the operation
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-flush/
        #
        def flush(arguments={})
          method = 'POST'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_flush'
          params = arguments.select do |k,v|
            [ :force,
              :full,
              :ignore_indices,
              :refresh ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
