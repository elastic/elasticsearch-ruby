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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Actions
      # Reindex documents.
      # Copy documents from a source to a destination.
      # You can copy all documents to the destination index or reindex a subset of the documents.
      # The source can be any existing index, alias, or data stream.
      # The destination must differ from the source.
      # For example, you cannot reindex a data stream into itself.
      # IMPORTANT: Reindex requires `_source` to be enabled for all documents in the source.
      # The destination should be configured as wanted before calling the reindex API.
      # Reindex does not copy the settings from the source or its associated template.
      # Mappings, shard counts, and replicas, for example, must be configured ahead of time.
      # If the Elasticsearch security features are enabled, you must have the following security privileges:
      # * The `read` index privilege for the source data stream, index, or alias.
      # * The `write` index privilege for the destination data stream, index, or index alias.
      # * To automatically create a data stream or index with a reindex API request, you must have the `auto_configure`, `create_index`, or `manage` index privilege for the destination data stream, index, or alias.
      # * If reindexing from a remote cluster, the `source.remote.user` must have the `monitor` cluster privilege and the `read` index privilege for the source data stream, index, or alias.
      # If reindexing from a remote cluster into a cluster using Elastic Stack, you must explicitly allow the remote host using the `reindex.remote.whitelist` node setting on the destination cluster.
      # If reindexing from a remote cluster into an Elastic Cloud Serverless project, only remote hosts from Elastic Cloud Hosted are allowed.
      # Automatic data stream creation requires a matching index template with data stream enabled.
      # The `dest` element can be configured like the index API to control optimistic concurrency control.
      # Omitting `version_type` or setting it to `internal` causes Elasticsearch to blindly dump documents into the destination, overwriting any that happen to have the same ID.
      # Setting `version_type` to `external` causes Elasticsearch to preserve the `version` from the source, create any documents that are missing, and update any documents that have an older version in the destination than they do in the source.
      # Setting `op_type` to `create` causes the reindex API to create only missing documents in the destination.
      # All existing documents will cause a version conflict.
      # IMPORTANT: Because data streams are append-only, any reindex request to a destination data stream must have an `op_type` of `create`.
      # A reindex can only add new documents to a destination data stream.
      # It cannot update existing documents in a destination data stream.
      # By default, version conflicts abort the reindex process.
      # To continue reindexing if there are conflicts, set the `conflicts` request body property to `proceed`.
      # In this case, the response includes a count of the version conflicts that were encountered.
      # Note that the handling of other error types is unaffected by the `conflicts` property.
      # Additionally, if you opt to count version conflicts, the operation could attempt to reindex more documents from the source than `max_docs` until it has successfully indexed `max_docs` documents into the target or it has gone through every document in the source query.
      # It's recommended to reindex on indices with a green status. Reindexing can fail when a node shuts down or crashes.
      # * When requested with `wait_for_completion=true` (default), the request fails if the node shuts down.
      # * When requested with `wait_for_completion=false`, a task id is returned, for use with the task management APIs. The task may disappear or fail if the node shuts down.
      # When retrying a failed reindex operation, it might be necessary to set `conflicts=proceed` or to first delete the partial destination index.
      # Additionally, dry runs, checking disk space, and fetching index recovery information can help address the root cause.
      # Refer to the linked documentation for examples of how to reindex documents.
      #
      # @option arguments [Boolean] :refresh If `true`, the request refreshes affected shards to make this operation visible to search.
      # @option arguments [Float] :requests_per_second The throttle for this request in sub-requests per second.
      #  By default, there is no throttle. Server default: -1.
      # @option arguments [Time] :scroll The period of time that a consistent view of the index should be maintained for scrolled search. Server default: 5m.
      # @option arguments [Integer, String] :slices The number of slices this task should be divided into.
      #  It defaults to one slice, which means the task isn't sliced into subtasks.Reindex supports sliced scroll to parallelize the reindexing process.
      #  This parallelization can improve efficiency and provide a convenient way to break the request down into smaller parts.NOTE: Reindexing from remote clusters does not support manual or automatic slicing.If set to `auto`, Elasticsearch chooses the number of slices to use.
      #  This setting will use one slice per shard, up to a certain limit.
      #  If there are multiple sources, it will choose the number of slices based on the index or backing index with the smallest number of shards. Server default: 1.
      # @option arguments [Integer] :max_docs The maximum number of documents to reindex.
      #  By default, all documents are reindexed.
      #  If it is a value less then or equal to `scroll_size`, a scroll will not be used to retrieve the results for the operation.If `conflicts` is set to `proceed`, the reindex operation could attempt to reindex more documents from the source than `max_docs` until it has successfully indexed `max_docs` documents into the target or it has gone through every document in the source query.
      # @option arguments [Time] :timeout The period each indexing waits for automatic index creation, dynamic mapping updates, and waiting for active shards.
      #  By default, Elasticsearch waits for at least one minute before failing.
      #  The actual wait time could be longer, particularly when multiple waits occur. Server default: 1m.
      # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
      #  Set it to `all` or any positive integer up to the total number of shards in the index (`number_of_replicas+1`).
      #  The default value is one, which means it waits for each primary shard to be active. Server default: 1.
      # @option arguments [Boolean] :wait_for_completion If `true`, the request blocks until the operation is complete. Server default: true.
      # @option arguments [Boolean] :require_alias If `true`, the destination must be an index alias.
      # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
      #  when they occur.
      # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
      #  returned by Elasticsearch.
      # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
      #  For example `"exists_time": "1h"` for humans and
      #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
      #  readable values will be omitted. This makes sense for responses being consumed
      #  only by machines.
      # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
      #  this option for debugging only.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex
      #
      def reindex(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'reindex' }

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        method = Elasticsearch::API::HTTP_POST
        path   = '_reindex'
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
