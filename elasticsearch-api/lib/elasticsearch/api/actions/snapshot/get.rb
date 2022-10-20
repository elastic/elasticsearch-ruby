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

module Elasticsearch
  module API
    module Snapshot
      module Actions
        # Returns information about a snapshot.
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [List] :snapshot A comma-separated list of snapshot names
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :ignore_unavailable Whether to ignore unavailable snapshots, defaults to false which means a SnapshotMissingException is thrown
        # @option arguments [Boolean] :index_details Whether to include details of each index in the snapshot, if those details are available. Defaults to false.
        # @option arguments [Boolean] :include_repository Whether to include the repository name in the snapshot info. Defaults to true.
        # @option arguments [String] :sort Allows setting a sort order for the result. Defaults to start_time (options: start_time, duration, name, repository, index_count, shard_count, failed_shard_count)
        # @option arguments [Integer] :size Maximum number of snapshots to return. Defaults to 0 which means return all that match without limit.
        # @option arguments [String] :order Sort order (options: asc, desc)
        # @option arguments [String] :from_sort_value Value of the current sort column at which to start retrieval.
        # @option arguments [String] :after Offset identifier to start pagination from as returned by the 'next' field in the response body.
        # @option arguments [Integer] :offset Numeric offset to start pagination based on the snapshots matching the request. Defaults to 0
        # @option arguments [String] :slm_policy_filter Filter snapshots by a comma-separated list of SLM policy names that snapshots belong to. Accepts wildcards. Use the special pattern '_none' to match snapshots without an SLM policy
        # @option arguments [Boolean] :verbose Whether to show verbose snapshot info or only show the basic info found in the repository index blob
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/modules-snapshots.html
        #
        def get(arguments = {})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_GET
          path   = "_snapshot/#{Utils.__listify(_repository)}/#{Utils.__listify(_snapshot)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body, headers).body }
          else
            perform_request(method, path, params, body, headers).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get, [
          :master_timeout,
          :ignore_unavailable,
          :index_details,
          :include_repository,
          :sort,
          :size,
          :order,
          :from_sort_value,
          :after,
          :offset,
          :slm_policy_filter,
          :verbose
        ].freeze)
      end
    end
  end
end
