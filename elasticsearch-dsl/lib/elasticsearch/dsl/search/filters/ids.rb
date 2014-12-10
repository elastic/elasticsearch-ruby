module Elasticsearch
  module DSL
    module Search
      module Filters

        # Ids filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-ids-filter.html
        #
        class Ids
          include BaseComponent

          option_method :type
          option_method :values
        end

      end
    end
  end
end
