module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Terms aggregation
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html
        class Terms
          include BaseAggregationComponent
        end

      end
    end
  end
end
