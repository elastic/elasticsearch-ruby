# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Auto generated from build hash 589cd632d091bc0a512c46d5d81ac1f961b60127
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Cat
      module Actions
        # Get node information
        #
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, kb, mb, gb, tb, pb)
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :full_id Return the full node ID instead of the shortened version (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display (options: build, completion.size, cpu, disk.avail, disk.total, disk.used, disk.used_percent, fielddata.evictions, fielddata.memory_size, file_desc.current, file_desc.max, file_desc.percent, flush.total, flush.total_time, get.current, get.exists_time, get.exists_total, get.missing_time, get.missing_total, get.time, get.total, heap.current, heap.max, heap.percent, http_address, id, indexing.delete_current, indexing.delete_time, indexing.delete_total, indexing.index_current, indexing.index_failed, indexing.index_failed_due_to_version_conflict, indexing.index_time, indexing.index_total, ip, jdk, load_1m, load_5m, load_15m, available_processors, mappings.total_count, mappings.total_estimated_overhead_in_bytes, master, merges.current, merges.current_docs, merges.current_size, merges.total, merges.total_docs, merges.total_size, merges.total_time, name, node.role, pid, port, query_cache.memory_size, query_cache.evictions, query_cache.hit_count, query_cache.miss_count, ram.current, ram.max, ram.percent, refresh.total, refresh.time, request_cache.memory_size, request_cache.evictions, request_cache.hit_count, request_cache.miss_count, script.compilations, script.cache_evictions, search.fetch_current, search.fetch_time, search.fetch_total, search.open_contexts, search.query_current, search.query_time, search.query_total, search.scroll_current, search.scroll_time, search.scroll_total, segments.count, segments.fixed_bitset_memory, segments.index_writer_memory, segments.memory, segments.version_map_memory, shard_stats.total_count, suggest.current, suggest.time, suggest.total, uptime, version)
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Boolean] :include_unloaded_segments If set to true segment stats will include stats for segments that are not currently loaded into memory
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/cat-nodes.html
        #
        def nodes(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.nodes' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_cat/nodes'
          params = Utils.process_params(arguments)
          params[:h] = Utils.__listify(params[:h], escape: false) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
