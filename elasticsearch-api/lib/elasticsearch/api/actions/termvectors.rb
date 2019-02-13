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

      # Return information and statistics about terms in the fields of a particular document
      #
      # @example Get statistics for an indexed document
      #
      #     client.indices.create index: 'my_index',
      #                           body: {
      #                             mappings: {
      #                               my_type: {
      #                                 properties: {
      #                                   text: {
      #                                     type: 'string',
      #                                     term_vector: 'with_positions_offsets_payloads'
      #                                   }
      #                                 }
      #                               }
      #                             }
      #                           }
      #
      #     client.index index: 'my_index', type: 'my_type', id: '1', body: { text: 'Foo Bar Fox' }
      #
      #     client.termvectors index: 'my_index', type: 'my_type', id: '1'
      #     # => { ..., "term_vectors" => { "text" => { "field_statistics" => { ... }, "terms" => { "bar" => ... } } }
      #
      #
      # @example Get statistics for an arbitrary document
      #
      #     client.termvector index: 'my_index', type: 'my_type',
      #                       body: {
      #                         doc: {
      #                           text: 'Foo Bar Fox'
      #                         }
      #                       }
      #     # => { ..., "term_vectors" => { "text" => { "field_statistics" => { ... }, "terms" => { "bar" => ... } } }
      #
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [String] :id The document ID
      # @option arguments [Hash] :body The request definition
      # @option arguments [Boolean] :term_statistics Whether total term frequency and
      #                                              document frequency should be returned
      # @option arguments [Boolean] :field_statistics Whether document count, sum of document frequencies
      #                                               and sum of total term frequencies should be returned
      # @option arguments [List] :fields A comma-separated list of fields to return
      # @option arguments [Boolean] :offsets Whether term offsets should be returned
      # @option arguments [Boolean] :positions Whether term positions should be returned
      # @option arguments [Boolean] :payloads Whether term payloads should be returned
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :realtime Specifies if requests are real-time as opposed to near-real-time
      #                                      (default: true)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :parent Parent ID of the documents
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/docs-termvectors.html
      #
      def termvectors(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        method = HTTP_GET
        endpoint = arguments.delete(:endpoint) || '_termvectors'

        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 (Utils.__escape(arguments[:type] || DEFAULT_DOC)),
                                 arguments[:id],
                                 endpoint

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # @deprecated Use the plural version, {#termvectors}
      #
      def termvector(arguments={})
        termvectors(arguments.merge :endpoint => '_termvector')
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:termvectors, [
          :term_statistics,
          :field_statistics,
          :fields,
          :offsets,
          :positions,
          :payloads,
          :preference,
          :realtime,
          :routing,
          :parent ].freeze)
    end
  end
end
