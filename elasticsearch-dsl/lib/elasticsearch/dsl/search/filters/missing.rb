module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which have a `null` value in the specified field
        # (ie. the reverse of the `exists` filter)
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             missing field: 'occupation'
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-missing-filter.html
        #
        class Missing
          include BaseComponent

          option_method :field
          option_method :existence
          option_method :null_value
        end

      end
    end
  end
end
