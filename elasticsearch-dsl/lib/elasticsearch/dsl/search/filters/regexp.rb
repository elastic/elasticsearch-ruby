module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching the specified regular expression
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             regexp :path do
        #               value '^/usr/?.*/var'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-regexp-filter.html
        #
        class Regexp
          include BaseComponent

          option_method :value
          option_method :flags
        end

      end
    end
  end
end
