module Elasticsearch
  module DSL
    module Search
      module Queries

        # Template query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-template-query.html
        #
        class Template
          include BaseComponent

          option_method :query
          option_method :params
        end

      end
    end
  end
end
