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

        # Force merge an index, list of indices, or all indices in the cluster.
        #
        # @example Fully force merge an index
        #
        #     client.indices.forcemerge index: 'foo', max_num_segments: 1
        #
        # @example Do not flush index after force-merging
        #
        #     client.indices.forcemerge index: 'foo', flush: false
        #
        # @example Do not expunge deleted documents after force-merging
        #
        #     client.indices.forcemerge index: 'foo', only_expunge_deletes: false
        #
        # @example Force merge a list of indices
        #
        #     client.indices.forcemerge index: ['foo', 'bar']
        #     client.indices.forcemerge index: 'foo,bar'
        #
        # @example forcemerge a list of indices matching wildcard expression
        #
        #     client.indices.forcemerge index: 'foo*'
        #
        # @example forcemerge all indices
        #
        #     client.indices.forcemerge index: '_all'
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Boolean] :flush Specify whether the index should be flushed after performing the operation (default: true)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Number] :max_num_segments The number of segments the index should be merged into (default: dynamic)
        # @option arguments [Boolean] :only_expunge_deletes Specify whether the operation should only expunge deleted documents
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-forcemerge.html
        #
        def forcemerge(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_forcemerge'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:forcemerge, [
            :flush,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :max_num_segments,
            :only_expunge_deletes ].freeze)
      end
    end
  end
end
