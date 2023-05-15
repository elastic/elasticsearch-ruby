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
    # Elasticsearch Client Helper for the Scroll API
    #
    # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/scroll-api.html
    #
    class ScrollHelper
      include Enumerable

      # Create a ScrollHelper
      #
      # @param [Elasticsearch::Client] client (Required) Instance of Elasticsearch client to use.
      # @param [String] index (Required) Index on which to perform the Bulk actions.
      # @param [Hash] body Body parameters to re-use in every scroll request
      # @param [Time] scroll Specify how long a consistent view of the index should be maintained for scrolled search
      #
      def initialize(client, index, body, scroll = '1m')
        @index = index
        @client = client
        @scroll = scroll
        @body = body
      end

      # Implementation of +each+ for Enumerable module inclusion
      #
      # @yieldparam document [Hash] yields a document found in the search hits.
      #
      def each(&block)
        @docs = []
        @scroll_id = nil
        refresh_docs
        for doc in @docs do
          refresh_docs
          yield doc
        end
        clear
      end

      # Results from a scroll.
      # Can be called repeatedly (e.g. in a loop) to get the scroll pages.
      #
      def results
        if @scroll_id
          scroll_request
        else
          initial_search
        end
      rescue StandardError => e
        raise e
      end

      # Clear Scroll and resets inner documents collection
      #
      def clear
        @client.clear_scroll(body: { scroll_id: @scroll_id }) if @scroll_id
        @docs = []
      end

      private

      def refresh_docs
        @docs ||= []
        @docs << results
        @docs.flatten!
      end

      def initial_search
        response = @client.search(index: @index, scroll: @scroll, body: @body)
        @scroll_id = response['_scroll_id']
        response['hits']['hits']
      end

      def scroll_request
        @client.scroll(body: {scroll: @scroll, scroll_id: @scroll_id})['hits']['hits']
      end
    end
  end
end
