module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents where the field value a specified prefix
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             prefix path: '/usr/local'
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-prefix-filter.html
        #
        class Prefix
          include BaseComponent
        end

      end
    end
  end
end
