# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which discards matching documents which overlap with another query
        #
        # @example
        #
        #     search do
        #       query do
        #         span_not include: { span_term: { title: 'disaster' } },
        #                  exclude: { span_term: { title: 'health' } }
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-not-query.html
        # @see https://lucene.apache.org/core/5_0_0/core/org/apache/lucene/search/spans/package-summary.html
        #
        class SpanNot
          include BaseComponent

          option_method :include
          option_method :exclude
          option_method :pre
          option_method :post
          option_method :dist
        end

      end
    end
  end
end
