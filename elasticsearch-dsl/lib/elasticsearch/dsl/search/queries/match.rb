module Elasticsearch
  module DSL
    module Search
      module Queries

        class Match
          include BaseComponent

          option_method :query
          option_method :operator
          option_method :boost
        end

      end
    end
  end
end
