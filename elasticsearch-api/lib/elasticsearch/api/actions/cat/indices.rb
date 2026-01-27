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
        # Get index information
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, kb, mb, gb, tb, pb)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display (options: health, status, index, uuid, pri, rep, docs.count, docs.deleted, creation.date, creation.date.string, store.size, pri.store.size, dataset.size, completion.size, pri.completion.size, fielddata.memory_size, pri.fielddata.memory_size, fielddata.evictions, pri.fielddata.evictions, query_cache.memory_size, pri.query_cache.memory_size, query_cache.evictions, pri.query_cache.evictions, request_cache.memory_size, pri.request_cache.memory_size, request_cache.evictions, pri.request_cache.evictions, request_cache.hit_count, pri.request_cache.hit_count, request_cache.miss_count, pri.request_cache.miss_count, flush.total, pri.flush.total, flush.total_time, pri.flush.total_time, get.current, pri.get.current, get.time, pri.get.time, get.total, pri.get.total, get.exists_time, pri.get.exists_time, get.exists_total, pri.get.exists_total, get.missing_time, pri.get.missing_time, get.missing_total, pri.get.missing_total, indexing.delete_current, pri.indexing.delete_current, indexing.delete_time, pri.indexing.delete_time, indexing.delete_total, pri.indexing.delete_total, indexing.index_current, pri.indexing.index_current, indexing.index_time, pri.indexing.index_time, indexing.index_total, pri.indexing.index_total, indexing.index_failed, pri.indexing.index_failed, indexing.index_failed_due_to_version_conflict, pri.indexing.index_failed_due_to_version_conflict, merges.current, pri.merges.current, merges.current_docs, pri.merges.current_docs, merges.current_size, pri.merges.current_size, merges.total, pri.merges.total, merges.total_docs, pri.merges.total_docs, merges.total_size, pri.merges.total_size, merges.total_time, pri.merges.total_time, refresh.total, pri.refresh.total, refresh.time, pri.refresh.time, refresh.external_total, pri.refresh.external_total, refresh.external_time, pri.refresh.external_time, refresh.listeners, pri.refresh.listeners, search.fetch_current, pri.search.fetch_current, search.fetch_time, pri.search.fetch_time, search.fetch_total, pri.search.fetch_total, search.open_contexts, pri.search.open_contexts, search.query_current, pri.search.query_current, search.query_time, pri.search.query_time, search.query_total, pri.search.query_total, search.scroll_current, pri.search.scroll_current, search.scroll_time, pri.search.scroll_time, search.scroll_total, pri.search.scroll_total, segments.count, pri.segments.count, segments.memory, pri.segments.memory, segments.index_writer_memory, pri.segments.index_writer_memory, segments.version_map_memory, pri.segments.version_map_memory, segments.fixed_bitset_memory, pri.segments.fixed_bitset_memory, warmer.current, pri.warmer.current, warmer.total, pri.warmer.total, warmer.total_time, pri.warmer.total_time, suggest.current, pri.suggest.current, suggest.time, pri.suggest.time, suggest.total, pri.suggest.total, memory.total, pri.memory.total, bulk.total_operations, pri.bulk.total_operations, bulk.total_time, pri.bulk.total_time, bulk.total_size_in_bytes, pri.bulk.total_size_in_bytes, bulk.avg_time, pri.bulk.avg_time, bulk.avg_size_in_bytes, pri.bulk.avg_size_in_bytes, dense_vector.value_count, pri.dense_vector.value_count, sparse_vector.value_count, pri.sparse_vector.value_count)
        # @option arguments [String] :health A health status ("green", "yellow", or "red" to filter only indices matching the specified health status (options: green, yellow, red, unknown, unavailable)
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :pri Set to true to return stats only for primary shards
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Boolean] :include_unloaded_segments If set to true segment stats will include stats for segments that are not currently loaded into memory
        # @option arguments [List] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/cat-indices.html
        #
        def indices(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.indices' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "_cat/indices/#{Utils.__listify(_index)}"
                   else
                     '_cat/indices'
                   end
          params = Utils.process_params(arguments)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
