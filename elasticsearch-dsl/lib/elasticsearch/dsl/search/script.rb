module Elasticsearch
  module DSL
    module Search

      # Wraps the `script` part of a search definition
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/5.5/query-dsl-script-query.html
      #

      #
      # @example
      #
      #     search do
      #       script do
      #         inline 'test'
      #         params [value: 7]
      #       end
      #     end
      #
      class Script
        include BaseComponent

        option_method :script
        option_method :inline
        option_method :params

      end
    end
  end
end
