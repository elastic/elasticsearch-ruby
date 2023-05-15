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
  module Helpers
    # Elasticsearch Client Helper for the Bulk API
    #
    # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-bulk.html
    class BulkHelper
      attr_accessor :index

      # Create a BulkHelper
      #
      # @param [Elasticsearch::Client] client (Required) - Instance of Elasticsearch client to use.
      # @param [String] index (Required) - Index on which to perform the Bulk actions.
      # @param [Hash] params (Optional) - Parameters to re-use in every bulk call
      #
      def initialize(client, index, params = {})
        @client = client
        @index = index
        @params = params
      end

      # Index documents using the Bulk API.
      #
      # @param [Array<Hash>] docs (Required) - The documents to be indexed.
      # @param [Hash] params - Parameters to use in the bulk ingestion. See the official Elastic documentation for Bulk API for parameters to send to the Bulk API.
      # @option params [Integer] slice - number of documents to send to the Bulk API for eatch batch of ingestion.
      # @param [Block] - Optional block to run after ingesting a batch of documents.
      #
      # @yield Elasticsearch::Transport::Response, [Array<Hash>] - Yields the response object from calling the Bulk API and the documents sent in the request.
      #
      def ingest(docs, params = {}, body = {}, &block)
        ingest_docs = docs.map { |doc| { index: { _index: @index, data: doc} } }
        if (slice = params.delete(:slice))
          ingest_docs.each_slice(slice) { |items| ingest(items, params, &block) }
        else
          bulk_request(ingest_docs, params, &block)
        end
      end

      # Delete documents using the Bulk API
      #
      # @param [Array] ids - Array of id's for documents to delete.
      # @param [Hash] params - Parameters to send to bulk delete.
      #
      def delete(ids, params = {}, body = {})
        delete_docs = ids.map { |id| { delete: { _index: @index, _id: id} } }
        @client.bulk({ body: delete_docs }.merge(params.merge(@params)))
      end

      # Update documents using the Bulk API
      #
      # @param [Array<Hash>] docs (Required) - The documents to be updated.
      # @option params [Integer] slice - number of documents to send to the Bulk API for eatch batch of updates.
      # @param [Block] - Optional block to run after ingesting a batch of documents.
      #
      # @yield Elasticsearch::Transport::Response, [Array<Hash>] - Yields the response object from calling the Bulk API and the documents sent in the request.
      #
      def update(docs, params = {}, body = {}, &block)
        ingest_docs = docs.map do |doc|
          { update: { _index: @index, _id: doc.delete('id'), data: { doc: doc } } }
        end
        if (slice = params.delete(:slice))
          ingest_docs.each_slice(slice) { |items| update(items, params, &block) }
        else
          bulk_request(ingest_docs, params, &block)
        end
      end

      private

      def bulk_request(ingest_docs, params, &block)
        response = @client.bulk({ body: ingest_docs }.merge(params.merge(@params)))
        yield response, ingest_docs if block_given?
        response
      end
    end
  end
end
