# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which returns document counts for defined IP ranges
        #
        # @example
        #
        #     search do
        #       aggregation :ips do
        #         ip_range do
        #           field 'ip'
        #           ranges [ { mask: '10.0.0.0/25' }, { mask: '10.0.0.127/25' } ]
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-iprange-aggregation.html
        #
        class IpRange
          include BaseAggregationComponent

          option_method :field
          option_method :ranges
        end

      end
    end
  end
end
