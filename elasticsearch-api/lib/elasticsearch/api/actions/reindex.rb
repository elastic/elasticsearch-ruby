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
    module Actions
      # Allows to copy documents from one index to another, optionally filtering the source
      # documents by a query, changing the destination index settings, or fetching the
      # documents from a remote cluster.
      #
      # @option arguments [Boolean] :refresh Should the affected indexes be refreshed?
      # @option arguments [Time] :timeout Time each individual bulk request should wait for shards that are unavailable.
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the reindex operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [Boolean] :wait_for_completion Should the request should block until the reindex is complete.
      # @option arguments [Number] :requests_per_second The throttle to set on this request in sub-requests per second. -1 means no throttle.
      # @option arguments [Time] :scroll Control how long to keep the search context alive
      # @option arguments [Number|string] :slices The number of slices this task should be divided into. Defaults to 1, meaning the task isn't sliced into subtasks. Can be set to `auto`.
      # @option arguments [Number] :max_docs Maximum number of documents to process (default: all documents)
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The search definition using the Query DSL and the prototype for the index request. (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/docs-reindex.html
      #
      def reindex(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'reindex' }

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body   = arguments.delete(:body)

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
