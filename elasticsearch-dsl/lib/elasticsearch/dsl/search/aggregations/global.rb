module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Defines a single bucket of all the documents matching a query
        #
        # @example
        #
        #     search do
        #       aggregation :all_documents do
        #         global
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-global-aggregation.html
        #
        class Global
          include BaseComponent
        end

      end
    end
  end
end
