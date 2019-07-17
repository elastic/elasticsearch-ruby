# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query that analyzes the text and creates a phrase query out of the analyzed text
        #
        # @example
        #
        #     search do
        #       query do
        #         match_phrase :content do
        #           query 'example content'
        #           analyzer 'standard'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query-phrase.html
        #
        class MatchPhrase
          include BaseComponent

          option_method :query
          option_method :analyzer
          option_method :boost
          option_method :slop
        end

      end
    end
  end
end
