module Elasticsearch
  module DSL
    module Search
      module Queries

        # QueryString query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html
        #
        class QueryString
          include BaseComponent

          option_method :query
          option_method :fields
          option_method :default_field
          option_method :default_operator
          option_method :analyzer
          option_method :allow_leading_wildcard
          option_method :lowercase_expanded_terms
          option_method :enable_position_increments
          option_method :fuzzy_max_expansions
          option_method :fuzziness
          option_method :fuzzy_prefix_length
          option_method :phrase_slop
          option_method :boost
          option_method :analyze_wildcard
          option_method :auto_generate_phrase_queries
          option_method :minimum_should_match
          option_method :lenient
          option_method :locale
          option_method :use_dis_max
          option_method :tie_breaker
        end

      end
    end
  end
end
