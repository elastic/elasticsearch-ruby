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
    module Snapshot
      module Actions
        # Verify the repository integrity.
        # Verify the integrity of the contents of a snapshot repository.
        # This API enables you to perform a comprehensive check of the contents of a repository, looking for any anomalies in its data or metadata which might prevent you from restoring snapshots from the repository or which might cause future snapshot create or delete operations to fail.
        # If you suspect the integrity of the contents of one of your snapshot repositories, cease all write activity to this repository immediately, set its `read_only` option to `true`, and use this API to verify its integrity.
        # Until you do so:
        # * It may not be possible to restore some snapshots from this repository.
        # * Searchable snapshots may report errors when searched or may have unassigned shards.
        # * Taking snapshots into this repository may fail or may appear to succeed but have created a snapshot which cannot be restored.
        # * Deleting snapshots from this repository may fail or may appear to succeed but leave the underlying data on disk.
        # * Continuing to write to the repository while it is in an invalid state may causing additional damage to its contents.
        # If the API finds any problems with the integrity of the contents of your repository, Elasticsearch will not be able to repair the damage.
        # The only way to bring the repository back into a fully working state after its contents have been damaged is by restoring its contents from a repository backup which was taken before the damage occurred.
        # You must also identify what caused the damage and take action to prevent it from happening again.
        # If you cannot restore a repository backup, register a new repository and use this for all future snapshot operations.
        # In some cases it may be possible to recover some of the contents of a damaged repository, either by restoring as many of its snapshots as needed and taking new snapshots of the restored data, or by using the reindex API to copy data from any searchable snapshots mounted from the damaged repository.
        # Avoid all operations which write to the repository while the verify repository integrity API is running.
        # If something changes the repository contents while an integrity verification is running then Elasticsearch may incorrectly report having detected some anomalies in its contents due to the concurrent writes.
        # It may also incorrectly fail to report some anomalies that the concurrent writes prevented it from detecting.
        # NOTE: This API is intended for exploratory use by humans. You should expect the request parameters and the response format to vary in future versions.
        # NOTE: This API may not work correctly in a mixed-version cluster.
        # The default values for the parameters of this API are designed to limit the impact of the integrity verification on other activities in your cluster.
        # For instance, by default it will only use at most half of the `snapshot_meta` threads to verify the integrity of each snapshot, allowing other snapshot operations to use the other half of this thread pool.
        # If you modify these parameters to speed up the verification process, you risk disrupting other snapshot-related operations in your cluster.
        # For large repositories, consider setting up a separate single-node Elasticsearch cluster just for running the integrity verification API.
        # The response exposes implementation details of the analysis which may change from version to version.
        # The response body format is therefore not considered stable and may be different in newer versions.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String, Array<String>] :repository The name of the snapshot repository. (*Required*)
        # @option arguments [Integer] :blob_thread_pool_concurrency If `verify_blob_contents` is `true`, this parameter specifies how many blobs to verify at once. Server default: 1.
        # @option arguments [Integer] :index_snapshot_verification_concurrency The maximum number of index snapshots to verify concurrently within each index verification. Server default: 1.
        # @option arguments [Integer] :index_verification_concurrency The number of indices to verify concurrently.
        #  The default behavior is to use the entire `snapshot_meta` thread pool. Server default: 0.
        # @option arguments [String] :max_bytes_per_sec If `verify_blob_contents` is `true`, this parameter specifies the maximum amount of data that Elasticsearch will read from the repository every second. Server default: 10mb.
        # @option arguments [Integer] :max_failed_shard_snapshots The number of shard snapshot failures to track during integrity verification, in order to avoid excessive resource usage.
        #  If your repository contains more than this number of shard snapshot failures, the verification will fail. Server default: 10000.
        # @option arguments [Integer] :meta_thread_pool_concurrency The maximum number of snapshot metadata operations to run concurrently.
        #  The default behavior is to use at most half of the `snapshot_meta` thread pool at once. Server default: 0.
        # @option arguments [Integer] :snapshot_verification_concurrency The number of snapshots to verify concurrently.
        #  The default behavior is to use at most half of the `snapshot_meta` thread pool at once. Server default: 0.
        # @option arguments [Boolean] :verify_blob_contents Indicates whether to verify the checksum of every data blob in the repository.
        #  If this feature is enabled, Elasticsearch will read the entire repository contents, which may be extremely slow and expensive.
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
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-repository-verify-integrity
        #
        def repository_verify_integrity(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.repository_verify_integrity' }

          defined_params = [:repository].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _repository = arguments.delete(:repository)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.listify(_repository)}/_verify_integrity"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
