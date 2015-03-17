module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which fall into a specified geographical distance
        #
        # @example Define the filter with a hash
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_distance location: '50.090223,14.399590', distance: '5km'
        #           end
        #         end
        #       end
        #     end
        #
        # @example Define the filter with a block
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_distance :location do
        #               lat '50.090223'
        #               lon '14.399590'
        #               distance '5km'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geo-distance.html
        #
        class GeoDistance
          include BaseComponent

          option_method :distance,      lambda { |*args| @hash[self.name.to_sym].update distance: args.pop }
          option_method :distance_type, lambda { |*args| @hash[self.name.to_sym].update distance_type: args.pop }
          option_method :lat,           lambda { |*args| @hash[self.name.to_sym][@args].update lat: args.pop }
          option_method :lon,           lambda { |*args| @hash[self.name.to_sym][@args].update lon: args.pop }

          def initialize(*args, &block)
            super
            @hash[self.name.to_sym] = { @args => {} } unless @args.empty?
          end
        end

      end
    end
  end
end
