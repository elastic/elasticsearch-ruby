# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A metric aggregator which returns the most relevant documents per bucket
        #
        # @example
        #
        #     search do
        #       aggregation :tags do
        #         terms do
        #           field 'tags'
        #
        #           aggregation :top_hits do
        #             top_hits sort: [ clicks: { order: 'desc' } ], _source: { include: 'title' }
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-top-hits-aggregation.html
        #
        class TopHits
          include BaseComponent

          option_method :from
          option_method :size
          option_method :sort
        end

      end
    end
  end
end
