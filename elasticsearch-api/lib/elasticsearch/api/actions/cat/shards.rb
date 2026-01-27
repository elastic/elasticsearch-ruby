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
        # Get shard information
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, kb, mb, gb, tb, pb)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display (options: completion.size, dataset.size, dense_vector.value_count, docs, fielddata.evictions, fielddata.memory_size, flush.total, flush.total_time, get.current, get.exists_time, get.exists_total, get.missing_time, get.missing_total, get.time, get.total, id, index, indexing.delete_current, indexing.delete_time, indexing.delete_total, indexing.index_current, indexing.index_failed_due_to_version_conflict, indexing.index_failed, indexing.index_time, indexing.index_total, ip, merges.current, merges.current_docs, merges.current_size, merges.total, merges.total_docs, merges.total_size, merges.total_time, node, prirep, query_cache.evictions, query_cache.memory_size, recoverysource.type, refresh.time, refresh.total, search.fetch_current, search.fetch_time, search.fetch_total, search.open_contexts, search.query_current, search.query_time, search.query_total, search.scroll_current, search.scroll_time, search.scroll_total, segments.count, segments.fixed_bitset_memory, segments.index_writer_memory, segments.memory, segments.version_map_memory, seq_no.global_checkpoint, seq_no.local_checkpoint, seq_no.max, shard, dsparse_vector.value_count, state, store, suggest.current, suggest.time, suggest.total, sync_id, unassigned.at, unassigned.details, unassigned.for, unassigned.reason)
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/cat-shards.html
        #
        def shards(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.shards' }

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
                     "_cat/shards/#{Utils.__listify(_index)}"
                   else
                     '_cat/shards'
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
