module Elasticsearch
  module DSL
    module Search
      module Queries

        # SimpleQueryString query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html
        #
        class SimpleQueryString
          include BaseComponent

          option_method :query
          option_method :fields
          option_method :default_operator
          option_method :analyzer
          option_method :flags
          option_method :lowercase_expanded_terms
          option_method :locale
          option_method :lenient
        end

      end
    end
  end
end
