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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Force a merge.
        # Perform the force merge operation on the shards of one or more indices.
        # For data streams, the API forces a merge on the shards of the stream's backing indices.
        # Merging reduces the number of segments in each shard by merging some of them together and also frees up the space used by deleted documents.
        # Merging normally happens automatically, but sometimes it is useful to trigger a merge manually.
        # WARNING: We recommend force merging only a read-only index (meaning the index is no longer receiving writes).
        # When documents are updated or deleted, the old version is not immediately removed but instead soft-deleted and marked with a "tombstone".
        # These soft-deleted documents are automatically cleaned up during regular segment merges.
        # But force merge can cause very large (greater than 5 GB) segments to be produced, which are not eligible for regular merges.
        # So the number of soft-deleted documents can then grow rapidly, resulting in higher disk usage and worse search performance.
        # If you regularly force merge an index receiving writes, this can also make snapshots more expensive, since the new documents can't be backed up incrementally.
        # **Blocks during a force merge**
        # Calls to this API block until the merge is complete (unless request contains +wait_for_completion=false+).
        # If the client connection is lost before completion then the force merge process will continue in the background.
        # Any new requests to force merge the same indices will also block until the ongoing force merge is complete.
        # **Running force merge asynchronously**
        # If the request contains +wait_for_completion=false+, Elasticsearch performs some preflight checks, launches the request, and returns a task you can use to get the status of the task.
        # However, you can not cancel this task as the force merge task is not cancelable.
        # Elasticsearch creates a record of this task as a document at +_tasks/<task_id>+.
        # When you are done with a task, you should delete the task document so Elasticsearch can reclaim the space.
        # **Force merging multiple indices**
        # You can force merge multiple indices with a single request by targeting:
        # * One or more data streams that contain multiple backing indices
        # * Multiple indices
        # * One or more aliases
        # * All data streams and indices in a cluster
        # Each targeted shard is force-merged separately using the force_merge threadpool.
        # By default each node only has a single +force_merge+ thread which means that the shards on that node are force-merged one at a time.
        # If you expand the +force_merge+ threadpool on a node then it will force merge its shards in parallel
        # Force merge makes the storage for the shard being merged temporarily increase, as it may require free space up to triple its size in case +max_num_segments parameter+ is set to +1+, to rewrite all segments into a new one.
        # **Data streams and time-based indices**
        # Force-merging is useful for managing a data stream's older backing indices and other time-based indices, particularly after a rollover.
        # In these cases, each index only receives indexing traffic for a certain period of time.
        # Once an index receive no more writes, its shards can be force-merged to a single segment.
        # This can be a good idea because single-segment shards can sometimes use simpler and more efficient data structures to perform searches.
        # For example:
        # +
        # POST /.ds-my-data-stream-2099.03.07-000001/_forcemerge?max_num_segments=1
        # +
        #
        # @option arguments [String, Array] :index A comma-separated list of index names; use +_all+ or empty string to perform the operation on all indices
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes +_all+ string or when no indices have been specified)
        # @option arguments [String, Array<String>] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        # @option arguments [Boolean] :flush Specify whether the index should be flushed after performing the operation (default: true)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Integer] :max_num_segments The number of segments the index should be merged into (default: dynamic)
        # @option arguments [Boolean] :only_expunge_deletes Specify whether the operation should only expunge deleted documents
        # @option arguments [Boolean] :wait_for_completion Should the request wait until the force merge is completed.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-forcemerge
        #
        def forcemerge(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.forcemerge' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "#{Utils.listify(_index)}/_forcemerge"
                   else
                     '_forcemerge'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
