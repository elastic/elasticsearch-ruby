module Elasticsearch
  module DSL
    module Search
      module Queries

        class Range
          include BaseComponent

          option_method :gte
          option_method :gt
          option_method :lte
          option_method :lt
          option_method :boost
        end

      end
    end
  end
end
