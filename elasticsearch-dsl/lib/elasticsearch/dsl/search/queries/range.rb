module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents matching the specified range
        #
        # @example Find documents within a numeric range
        #
        #     search do
        #       query do
        #         range :age do
        #           gte 10
        #           lte 20
        #         end
        #       end
        #     end
        #
        # @example Find documents published within a date range
        #
        #     search do
        #       query do
        #         range :published_on do
        #           gte '2013-01-01'
        #           lte 'now'
        #           time_zone '+1:00'
        #         end
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-query.html
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
