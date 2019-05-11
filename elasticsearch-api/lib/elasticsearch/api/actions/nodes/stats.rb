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
    module Nodes
      module Actions

        # Returns statistical information about nodes in the cluster.
        #
        # @example Return statistics about JVM
        #
        #     client.nodes.stats metric: 'jvm'
        #
        # @example Return statistics about field data structures for all fields
        #
        #     client.nodes.stats metric: 'indices', index_metric: 'fielddata', fields: '*', human: true
        #
        # @option arguments [List] :metric Limit the information returned to the specified metrics (options: _all,breaker,fs,http,indices,jvm,os,process,thread_pool,transport,discovery)
        # @option arguments [List] :index_metric Limit the information returned for `indices` metric to the specific index metrics. Isn't used if `indices` (or `all`) metric isn't specified. (options: _all,completion,docs,fielddata,query_cache,flush,get,indexing,merge,request_cache,refresh,search,segments,store,warmer,suggest)
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :completion_fields A comma-separated list of fields for `fielddata` and `suggest` index metric (supports wildcards)
        # @option arguments [List] :fielddata_fields A comma-separated list of fields for `fielddata` index metric (supports wildcards)
        # @option arguments [List] :fields A comma-separated list of fields for `fielddata` and `completion` index metric (supports wildcards)
        # @option arguments [Boolean] :groups A comma-separated list of search groups for `search` index metric
        # @option arguments [String] :level Return indices stats aggregated at index, node or shard level (options: indices, node, shards)
        # @option arguments [List] :types A comma-separated list of document types for the `indexing` index metric
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :include_segment_file_sizes Whether to report the aggregated disk usage of each one of the Lucene index files (only applies if segment stats are requested)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/cluster-nodes-stats.html
        #
        def stats(arguments={})
          arguments = arguments.clone
          node_id = arguments.delete(:node_id)

          path   = Utils.__pathify '_nodes',
                                   Utils.__listify(node_id),
                                   'stats',
                                   Utils.__listify(arguments.delete(:metric)),
                                   Utils.__listify(arguments.delete(:index_metric))

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          [:completion_fields, :fielddata_fields, :fields, :groups, :types].each do |key|
            params[key] = Utils.__listify(params[key]) if params[key]
          end

          body   = nil

          perform_request(HTTP_GET, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:stats, [
            :completion_fields,
            :fielddata_fields,
            :fields,
            :groups,
            :level,
            :types,
            :timeout,
            :include_segment_file_sizes ].freeze)
      end
    end
  end
end
