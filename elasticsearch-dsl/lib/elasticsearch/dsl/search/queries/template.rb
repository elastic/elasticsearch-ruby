module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which allows to use Mustache templates for query definitions
        #
        # @example
        #
        #     search do
        #       query do
        #         template do
        #           query  match: { content: '{query_string}' }
        #           params query_string: 'twitter'
        #         end
        #       end
        #     end
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
