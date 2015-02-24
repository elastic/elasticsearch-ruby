module Elasticsearch
  module DSL
    module Search
      module Filters

        # GeoDistance filter
        #
        # @example
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
