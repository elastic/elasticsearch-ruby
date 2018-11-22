# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Actions

      # Copy documents from one index to another, potentially changing
      # its settings, mappings and the documents itself.
      #
      # @example Copy documents into a different index
      #
      #     client.reindex body: { source: { index: 'test1' }, dest: { index: 'test2' } }
      #
      # @example Limit the copied documents with a query
      #
      #     client.reindex body: {
      #       source: {
      #         index: 'test1',
      #         query: { terms: { category: ['one', 'two'] }  }
      #       },
      #       dest: {
      #         index: 'test2'
      #       }
      #     }
      #
      # @example Remove a field from reindexed documents
      #
      #     client.reindex body: {
      #       source: {
      #         index: 'test1'
      #       },
      #       dest: {
      #         index: 'test3'
      #       },
      #       script: {
      #         inline: 'ctx._source.remove("category")'
      #       }
      #     }
      #
      # @option arguments [Hash] :body The definition of the operation (source index, target index, ...)
      #                                (*Required*)
      # @option arguments [Boolean] :refresh Whether the affected indexes should be refreshed
      # @option arguments [Time] :timeout Time each individual bulk request should wait for shards
      #                                   that are unavailable. (Default: 1m)
      # @option arguments [String] :consistency Explicit write consistency setting for the operation
      #                                        (Options: one, quorum, all)
      # @option arguments [Boolean] :wait_for_completion Whether the request should block and wait until
      #                                                  the operation has completed
      # @option arguments [Float] :requests_per_second The throttling for this request in sub-requests per second.
      #                                                0 means set no throttling (default)
      # @option arguments [Integer] :slices The number of slices this request should be divided into.
      #                                     Defaults to 1 meaning the request isn't sliced into sub-requests.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html
      #
      def reindex(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = 'POST'
        path   = "_reindex"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:reindex, [
          :refresh,
          :timeout,
          :consistency,
          :wait_for_completion,
          :requests_per_second,
          :slices ].freeze)
    end
  end
end
