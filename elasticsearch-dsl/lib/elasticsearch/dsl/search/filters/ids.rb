module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching the specified IDs
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             ids values: [1, 2, 3]
        #           end
        #         end
        #       end
        #     end
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
