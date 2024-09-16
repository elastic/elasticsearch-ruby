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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Snapshot
      module Actions
        # Verifies the integrity of the contents of a snapshot repository
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [Number] :meta_thread_pool_concurrency Number of threads to use for reading metadata
        # @option arguments [Number] :blob_thread_pool_concurrency Number of threads to use for reading blob contents
        # @option arguments [Number] :snapshot_verification_concurrency Number of snapshots to verify concurrently
        # @option arguments [Number] :index_verification_concurrency Number of indices to verify concurrently
        # @option arguments [Number] :index_snapshot_verification_concurrency Number of snapshots to verify concurrently within each index
        # @option arguments [Number] :max_failed_shard_snapshots Maximum permitted number of failed shard snapshots
        # @option arguments [Boolean] :verify_blob_contents Whether to verify the contents of individual blobs
        # @option arguments [String] :max_bytes_per_sec Rate limit for individual blob verification
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
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
          path   = "_snapshot/#{Utils.__listify(_repository)}/_verify_integrity"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
