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
    module Actions
      # Update documents.
      # Updates documents that match the specified query.
      # If no query is specified, performs an update on every document in the data stream or index without modifying the source, which is useful for picking up mapping changes.
      # If the Elasticsearch security features are enabled, you must have the following index privileges for the target data stream, index, or alias:
      # * +read+
      # * +index+ or +write+
      # You can specify the query criteria in the request URI or the request body using the same syntax as the search API.
      # When you submit an update by query request, Elasticsearch gets a snapshot of the data stream or index when it begins processing the request and updates matching documents using internal versioning.
      # When the versions match, the document is updated and the version number is incremented.
      # If a document changes between the time that the snapshot is taken and the update operation is processed, it results in a version conflict and the operation fails.
      # You can opt to count version conflicts instead of halting and returning by setting +conflicts+ to +proceed+.
      # Note that if you opt to count version conflicts, the operation could attempt to update more documents from the source than +max_docs+ until it has successfully updated +max_docs+ documents or it has gone through every document in the source query.
      # NOTE: Documents with a version equal to 0 cannot be updated using update by query because internal versioning does not support 0 as a valid version number.
      # While processing an update by query request, Elasticsearch performs multiple search requests sequentially to find all of the matching documents.
      # A bulk update request is performed for each batch of matching documents.
      # Any query or update failures cause the update by query request to fail and the failures are shown in the response.
      # Any update requests that completed successfully still stick, they are not rolled back.
      # **Throttling update requests**
      # To control the rate at which update by query issues batches of update operations, you can set +requests_per_second+ to any positive decimal number.
      # This pads each batch with a wait time to throttle the rate.
      # Set +requests_per_second+ to +-1+ to turn off throttling.
      # Throttling uses a wait time between batches so that the internal scroll requests can be given a timeout that takes the request padding into account.
      # The padding time is the difference between the batch size divided by the +requests_per_second+ and the time spent writing.
      # By default the batch size is 1000, so if +requests_per_second+ is set to +500+:
      # +
      # target_time = 1000 / 500 per second = 2 seconds
      # wait_time = target_time - write_time = 2 seconds - .5 seconds = 1.5 seconds
      # +
      # Since the batch is issued as a single _bulk request, large batch sizes cause Elasticsearch to create many requests and wait before starting the next set.
      # This is "bursty" instead of "smooth".
      # **Slicing**
      # Update by query supports sliced scroll to parallelize the update process.
      # This can improve efficiency and provide a convenient way to break the request down into smaller parts.
      # Setting +slices+ to +auto+ chooses a reasonable number for most data streams and indices.
      # This setting will use one slice per shard, up to a certain limit.
      # If there are multiple source data streams or indices, it will choose the number of slices based on the index or backing index with the smallest number of shards.
      # Adding +slices+ to +_update_by_query+ just automates the manual process of creating sub-requests, which means it has some quirks:
      # * You can see these requests in the tasks APIs. These sub-requests are "child" tasks of the task for the request with slices.
      # * Fetching the status of the task for the request with +slices+ only contains the status of completed slices.
      # * These sub-requests are individually addressable for things like cancellation and rethrottling.
      # * Rethrottling the request with +slices+ will rethrottle the unfinished sub-request proportionally.
      # * Canceling the request with slices will cancel each sub-request.
      # * Due to the nature of slices each sub-request won't get a perfectly even portion of the documents. All documents will be addressed, but some slices may be larger than others. Expect larger slices to have a more even distribution.
      # * Parameters like +requests_per_second+ and +max_docs+ on a request with slices are distributed proportionally to each sub-request. Combine that with the point above about distribution being uneven and you should conclude that using +max_docs+ with +slices+ might not result in exactly +max_docs+ documents being updated.
      # * Each sub-request gets a slightly different snapshot of the source data stream or index though these are all taken at approximately the same time.
      # If you're slicing manually or otherwise tuning automatic slicing, keep in mind that:
      # * Query performance is most efficient when the number of slices is equal to the number of shards in the index or backing index. If that number is large (for example, 500), choose a lower number as too many slices hurts performance. Setting slices higher than the number of shards generally does not improve efficiency and adds overhead.
      # * Update performance scales linearly across available resources with the number of slices.
      # Whether query or update performance dominates the runtime depends on the documents being reindexed and cluster resources.
      # **Update the document source**
      # Update by query supports scripts to update the document source.
      # As with the update API, you can set +ctx.op+ to change the operation that is performed.
      # Set +ctx.op = "noop"+ if your script decides that it doesn't have to make any changes.
      # The update by query operation skips updating the document and increments the +noop+ counter.
      # Set +ctx.op = "delete"+ if your script decides that the document should be deleted.
      # The update by query operation deletes the document and increments the +deleted+ counter.
      # Update by query supports only +index+, +noop+, and +delete+.
      # Setting +ctx.op+ to anything else is an error.
      # Setting any other field in +ctx+ is an error.
      # This API enables you to only modify the source of matching documents; you cannot move them.
      #
      # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases to search.
      #  It supports wildcards (+*+).
      #  To search all data streams or indices, omit this parameter or use +*+ or +_all+. (*Required*)
      # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
      #  This behavior applies even if the request targets other open indices.
      #  For example, a request targeting +foo*,bar*+ returns an error if an index starts with +foo+ but no index starts with +bar+. Server default: true.
      # @option arguments [String] :analyzer The analyzer to use for the query string.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [Boolean] :analyze_wildcard If +true+, wildcard and prefix queries are analyzed.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [String] :conflicts The preferred behavior when update by query hits version conflicts: +abort+ or +proceed+. Server default: abort.
      # @option arguments [String] :default_operator The default operator for query string query: +AND+ or +OR+.
      #  This parameter can be used only when the +q+ query string parameter is specified. Server default: OR.
      # @option arguments [String] :df The field to use as default where no field prefix is given in the query string.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
      #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
      #  It supports comma-separated values, such as +open,hidden+.
      #  Valid values are: +all+, +open+, +closed+, +hidden+, +none+.
      # @option arguments [Integer] :from Starting offset (default: 0)
      # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
      # @option arguments [Boolean] :lenient If +true+, format-based query failures (such as providing text to a numeric field) in the query string will be ignored.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [Integer] :max_docs The maximum number of documents to process.
      #  It defaults to all documents.
      #  When set to a value less then or equal to +scroll_size+ then a scroll will not be used to retrieve the results for the operation.
      # @option arguments [String] :pipeline The ID of the pipeline to use to preprocess incoming documents.
      #  If the index has a default ingest pipeline specified, then setting the value to +_none+ disables the default ingest pipeline for this request.
      #  If a final pipeline is configured it will always run, regardless of the value of this parameter.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  It is random by default.
      # @option arguments [String] :q A query in the Lucene query string syntax.
      # @option arguments [Boolean] :refresh If +true+, Elasticsearch refreshes affected shards to make the operation visible to search after the request completes.
      #  This is different than the update API's +refresh+ parameter, which causes just the shard that received the request to be refreshed.
      # @option arguments [Boolean] :request_cache If +true+, the request cache is used for this request.
      #  It defaults to the index-level setting.
      # @option arguments [Float] :requests_per_second The throttle for this request in sub-requests per second. Server default: -1.
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Time] :scroll The period to retain the search context for scrolling. Server default: 5m.
      # @option arguments [Integer] :scroll_size The size of the scroll request that powers the operation. Server default: 1000.
      # @option arguments [Time] :search_timeout An explicit timeout for each search request.
      #  By default, there is no timeout.
      # @option arguments [String] :search_type The type of the search operation. Available options include +query_then_fetch+ and +dfs_query_then_fetch+.
      # @option arguments [Integer, String] :slices The number of slices this task should be divided into. Server default: 1.
      # @option arguments [Array<String>] :sort A comma-separated list of <field>:<direction> pairs.
      # @option arguments [Array<String>] :stats The specific +tag+ of the request for logging and statistical purposes.
      # @option arguments [Integer] :terminate_after The maximum number of documents to collect for each shard.
      #  If a query reaches this limit, Elasticsearch terminates the query early.
      #  Elasticsearch collects documents before sorting.IMPORTANT: Use with caution.
      #  Elasticsearch applies this parameter to each shard handling the request.
      #  When possible, let Elasticsearch perform early termination automatically.
      #  Avoid specifying this parameter for requests that target data streams with backing indices across multiple data tiers.
      # @option arguments [Time] :timeout The period each update request waits for the following operations: dynamic mapping updates, waiting for active shards.
      #  By default, it is one minute.
      #  This guarantees Elasticsearch waits for at least the timeout before failing.
      #  The actual wait time could be longer, particularly when multiple waits occur. Server default: 1m.
      # @option arguments [Boolean] :version If +true+, returns the document version as part of a hit.
      # @option arguments [Boolean] :version_type Should the document increment the version number (internal) on hit or not (reindex)
      # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
      #  Set to +all+ or any positive integer up to the total number of shards in the index (+number_of_replicas+1+).
      #  The +timeout+ parameter controls how long each write request waits for unavailable shards to become available.
      #  Both work exactly the way they work in the bulk API. Server default: 1.
      # @option arguments [Boolean] :wait_for_completion If +true+, the request blocks until the operation is complete.
      #  If +false+, Elasticsearch performs some preflight checks, launches the request, and returns a task ID that you can use to cancel or get the status of the task.
      #  Elasticsearch creates a record of this task as a document at +.tasks/task/${taskId}+. Server default: true.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update-by-query
      #
      def update_by_query(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'update_by_query' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = "#{Utils.listify(_index)}/_update_by_query"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
