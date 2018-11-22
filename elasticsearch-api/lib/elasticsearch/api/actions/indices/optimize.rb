# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Indices
      module Actions

        # Perform an index optimization.
        #
        # The "optimize" operation merges the index segments, increasing search performance.
        # It corresponds to a Lucene "merge" operation.
        #
        # @deprecated The "optimize" action has been deprecated in favor of forcemerge [https://github.com/elastic/elasticsearch/pull/13778]
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
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [Boolean] :flush Specify whether the index should be flushed after performing the operation
        #                                    (default: true)
        # @option arguments [Boolean] :force Force a merge operation to run, even when the index has a single segment
        #                                    (default: true)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        # @option arguments [Number] :max_num_segments The number of segments the index should be merged into
        #                                              (default: dynamic)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
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
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_optimize'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:optimize, [
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :flush,
            :force,
            :master_timeout,
            :max_num_segments,
            :only_expunge_deletes,
            :operation_threading,
            :refresh,
            :wait_for_merge ].freeze)
      end
    end
  end
end
