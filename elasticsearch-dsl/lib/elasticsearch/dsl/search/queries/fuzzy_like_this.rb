# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents which are similar to the specified text
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy_like_this do
        #           like_text 'Eyjafjallajökull'
        #           fields [:title, :abstract, :content]
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-flt-query.html
        #
        class FuzzyLikeThis
          include BaseComponent

          option_method :fields
          option_method :like_text
          option_method :fuzziness
          option_method :analyzer
          option_method :max_query_terms
          option_method :prefix_length
          option_method :boost
          option_method :ignore_tf
        end

      end
    end
  end
end
