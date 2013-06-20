module Elasticsearch
  module API
    module Indices
      module Actions

        # Perform an index optimization.
        #
        # The "optimize" operation merges the index segments, increasing search performance.
        # It corresponds to a Lucene "merge" operation.
        #
        # @example Fully optimize an index (merge to one segment)
        #
        #     client.indices.optimize index: 'foo', max_num_segments: 1, wait_for_merge: false
        #
        # @note The optimize operation is handled automatically by Elasticsearch, you don't need to perform it manually.
        #       The operation is expensive in terms of resources (I/O, CPU, memory) and can take a long time to
        #       finish, potentially reducing operability of your cluster; schedule the manual optimization accordingly.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all`
        #                                 or empty string to perform the operation on all indices
        # @option arguments [Boolean] :flush Specify whether the index should be flushed after performing the operation
        #                                    (default: true)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        # @option arguments [Number] :max_num_segments The number of segments the index should be merged into
        #                                              (default: dynamic)
        # @option arguments [Boolean] :only_expunge_deletes Specify whether the operation should only expunge
        #                                                   deleted documents
        # @option arguments [Boolean] :refresh Specify whether the index should be refreshed after performing the operation
        #                                      (default: true)
        # @option arguments [Boolean] :wait_for_merge Specify whether the request should block until the merge process
        #                                             is finished (default: true)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-optimize/
        #
        def optimize(arguments={})
          method = 'POST'
          path   = Utils.__pathify( Utils.__listify(arguments[:index]), '_optimize' )
          params = arguments.select do |k,v|
            [ :flush,
              :ignore_indices,
              :max_num_segments,
              :only_expunge_deletes,
              :operation_threading,
              :refresh,
              :wait_for_merge ].include?(k)
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
