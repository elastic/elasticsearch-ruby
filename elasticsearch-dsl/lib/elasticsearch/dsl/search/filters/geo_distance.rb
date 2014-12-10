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

          option_method :lat
          option_method :lon

          def initialize(*args, &block)
            super
          end
        end

      end
    end
  end
end
