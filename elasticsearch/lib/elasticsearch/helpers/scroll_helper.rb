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
    class ScrollHelper
      include Enumerable

      def initialize(client, index, body, scroll = '1m')
        @index = index
        @client = client
        @scroll = scroll
        @body = body
        @docs = []
      end

      def each(&block)
        refresh_docs
        for doc in @docs do
          refresh_docs
          yield doc
        end
        clear
        @docs = []
      end

      def results
        if @scroll_id
          @client.scroll(body: {scroll: @scroll, scroll_id: @scroll_id})['hits']['hits']
        else
          initial_search
        end
      rescue Elastic::Transport::Transport::Errors::NotFound => e
        if e.message.match?('search_context_missing_exception')
          initial_search
        else
          raise e
        end
      end

      private

      def refresh_docs
        @docs << results
        @docs.flatten!
      end

      def initial_search
        response = @client.search(index: @index, scroll: @scroll, body: @body)
        @scroll_id = response['_scroll_id']
        response['hits']['hits']
      end

      def clear
        @client.clear_scroll(body: { scroll_id: @scroll_id })
      end
    end
  end
end
