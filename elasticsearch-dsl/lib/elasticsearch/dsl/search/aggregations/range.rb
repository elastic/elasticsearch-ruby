module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which returns document counts for custom numerical ranges,
        # which define the buckets
        #
        # @example
        #
        #     search do
        #       aggregation :clicks do
        #         range field: 'clicks',
        #               ranges: [
        #                 { to: 10 },
        #                 { from: 10, to: 20 }
        #               ]
        #       end
        #     end
        #
        # @example Using custom names for the ranges
        #
        #     search do
        #       aggregation :clicks do
        #         range do
        #           field 'clicks'
        #           key :low, to: 10
        #           key :mid, from: 10, to: 20
        #         end
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-range-aggregation.html
        class Range
          include BaseAggregationComponent

          option_method :field
          option_method :script
          option_method :params

          def key(key, value)
            @hash[name].update(@args) if @args
            @hash[name][:keyed]  ||= true
            @hash[name][:ranges] ||= []
            @hash[name][:ranges] << value.merge(key: key) unless @hash[name][:ranges].any? { |i| i[:key] == key }
            self
          end
        end

      end
    end
  end
end
