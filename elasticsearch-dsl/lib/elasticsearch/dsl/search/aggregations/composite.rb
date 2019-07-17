# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations
        #
        # A multi-bucket aggregation that creates composite buckets from different sources.
        #
        # @example
        #
        #  search do
        #    aggregation :things do
        #      composite do
        #        size 2000
        #        sources [
        #          { thing1: { terms: { field: 'thing1.field1' } } },
        #          { thing2: { terms: { field: 'thing2.field2' } } }
        #        ]
        #        after after_key
        #      end
        #    end
        #  end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-composite-aggregation.html
        #
        class Composite
          include BaseAggregationComponent

          option_method :size
          option_method :sources
          option_method :after

          def to_hash(_options={})
            super
            # remove :after if no value is given
            @hash[name.to_sym].delete(:after) if @hash[name.to_sym].is_a?(Hash) && @hash[name.to_sym][:after].nil?

            @hash
          end
        end
      end
    end
  end
end
