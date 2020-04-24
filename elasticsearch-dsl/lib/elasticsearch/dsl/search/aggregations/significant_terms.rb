# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation that returns interesting or unusual occurrences of terms in a set
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
        #         significant_terms do
        #           field :body
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-significantterms-aggregation.html
        #
        class SignificantTerms
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
