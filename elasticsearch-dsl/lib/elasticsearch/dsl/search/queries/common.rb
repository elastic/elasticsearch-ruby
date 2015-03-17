module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which executes the search for low frequency terms first, and high frequency ("common")
        # terms second
        #
        # @example
        #
        #     search do
        #       query do
        #         common :body do
        #           query 'shakespeare to be or not to be'
        #         end
        #       end
        #     end
        #
        # This query is frequently used when a stopwords-based approach loses too much recall and/or precision.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-common-terms-query.html
        #
        class Common
          include BaseComponent

          option_method :query
          option_method :cutoff_frequency
          option_method :low_freq_operator
          option_method :minimum_should_match
          option_method :boost
          option_method :analyzer
          option_method :disable_coord
        end

      end
    end
  end
end
