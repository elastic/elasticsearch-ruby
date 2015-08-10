module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents that have terms in a specified range
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             range :age do
        #               gte 10
        #               lte 20
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-filter.html
        #
        class Range
          include BaseComponent

          option_method :gte
          option_method :gt
          option_method :lte
          option_method :lt
          option_method :boost
          option_method :time_zone
          option_method :format
        end

      end
    end
  end
end
