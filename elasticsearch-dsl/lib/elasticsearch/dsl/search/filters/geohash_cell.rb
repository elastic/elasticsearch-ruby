module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which translates lat/lon values into a geohash with the specified precision
        # and returns all documents which fall into it
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geohash_cell :location do
        #               lat '50.090223'
        #               lon '14.399590'
        #               precision '5km'
        #               neighbors true
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geohash-cell-filter.html
        #
        class GeohashCell
          include BaseComponent

          option_method :precision, lambda { |*args| @hash[self.name.to_sym].update precision: args.pop }
          option_method :lat,       lambda { |*args| @hash[self.name.to_sym][@args].update lat: args.pop }
          option_method :lon,       lambda { |*args| @hash[self.name.to_sym][@args].update lon: args.pop }
          option_method :neighbors, lambda { |*args| @hash[self.name.to_sym].update neighbors: args.pop }

          def initialize(*args, &block)
            super
            @hash[self.name.to_sym] = { @args => {} } unless @args.empty?
          end
        end
      end
    end
  end
end
