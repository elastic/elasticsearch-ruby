# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching the specified terms
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             term color: 'red'
        #           end
        #         end
        #       end
        #     end
        #
        # @note The specified terms are *not analyzed* (lowercased, stemmed, etc),
        #       so they must match the indexed terms.
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-filter.html
        #
        class Term
          include BaseComponent
        end

      end
    end
  end
end
