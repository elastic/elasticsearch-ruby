module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Terms aggregation
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
