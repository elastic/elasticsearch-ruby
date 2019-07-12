# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which fall into a specified geographical distance range
        #
        # @example Define the filter with a hash
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_distance location: '50.090223,14.399590', gte: '2km', lte: '5km'
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/guide/current/geo-distance.html
        #
        class GeoDistanceRange
          include BaseComponent

          option_method :lat
          option_method :lon
        end

      end
    end
  end
end
