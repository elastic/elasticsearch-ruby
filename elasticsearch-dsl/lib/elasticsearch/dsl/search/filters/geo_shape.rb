# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which fall into a specified geographical shape
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_shape :location do
        #               shape type: 'envelope',
        #                     coordinates: [[14.2162566185,49.9415476869], [14.7149200439,50.1815123678]]
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-geo-shape-filter.html
        #
        class GeoShape
          include BaseComponent

          option_method :shape
          option_method :indexed_shape
        end

      end
    end
  end
end
