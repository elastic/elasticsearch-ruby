# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # An aggregation that returns interesting or unusual occurrences of free-text terms in a set. 
        #
        # @example
        #
        #     search do
        #       query do
        #         match :title do
        #           query 'fink'
        #         end
        #       end
        #
        #       aggregation :interesting_terms do
        #         significant_text do
        #           field :body
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/6.8/search-aggregations-bucket-significanttext-aggregation.html
        #
        class SignificantText
          include BaseAggregationComponent

          option_method :field
          option_method :size
          option_method :shard_size
          option_method :min_doc_count
          option_method :shard_min_doc_count
          option_method :include
          option_method :exclude
          option_method :background_filter
          option_method :mutual_information
          option_method :chi_square
          option_method :gnd
        end

      end
    end
  end
end
