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
    module Indices
      module Actions

        # Create an index.
        #
        # Pass the index `settings` and `mappings` in the `:body` attribute.
        #
        # @example Create an index with specific settings, custom analyzers and mappings
        #
        #     client.indices.create index: 'test',
        #                           body: {
        #                             settings: {
        #                               index: {
        #                                 number_of_shards: 1,
        #                                 number_of_replicas: 0,
        #                                 'routing.allocation.include.name' => 'node-1'
        #                               },
        #                               analysis: {
        #                                 filter: {
        #                                   ngram: {
        #                                     type: 'nGram',
        #                                     min_gram: 3,
        #                                     max_gram: 25
        #                                   }
        #                                 },
        #                                 analyzer: {
        #                                   ngram: {
        #                                     tokenizer: 'whitespace',
        #                                     filter: ['lowercase', 'stop', 'ngram'],
        #                                     type: 'custom'
        #                                   },
        #                                   ngram_search: {
        #                                     tokenizer: 'whitespace',
        #                                     filter: ['lowercase', 'stop'],
        #                                     type: 'custom'
        #                                   }
        #                                 }
        #                               }
        #                             },
        #                             mappings: {
        #                               properties: {
        #                                 title: {
        #                                   type: 'multi_field',
        #                                   fields: {
        #                                       title:  { type: 'string', analyzer: 'snowball' },
        #                                       exact:  { type: 'string', analyzer: 'keyword' },
        #                                       ngram:  { type: 'string',
        #                                                 index_analyzer: 'ngram',
        #                                                 search_analyzer: 'ngram_search'
        #                                       }
        #                                   }
        #                                 }
        #                               }
        #                             }
        #                           }
        #
        # @option arguments [String] :index The name of the index (*Required*)
        # @option arguments [Hash] :body Optional configuration for the index (`settings` and `mappings`)
        # @option arguments [Boolean] :include_type_name Whether a type should be expected in the body of the mappings.
        # @option arguments [Boolean] :update_all_types Whether to update the mapping for all fields
        #                                               with the same name across all types
        # @option arguments [Number] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :master_timeout Timeout for connection to master
        #
        # @see https://www.elastic.co/guide/reference/api/admin-indices-create-index/
        #
        def create(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__escape(arguments[:index])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:create, [
            :include_type_name,
            :wait_for_active_shards,
            :timeout,
            :master_timeout ].freeze)
      end
    end
  end
end
