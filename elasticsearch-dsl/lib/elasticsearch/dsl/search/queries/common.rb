module Elasticsearch
  module DSL
    module Search
      module Queries

        # Common query
        #
        # @example
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
