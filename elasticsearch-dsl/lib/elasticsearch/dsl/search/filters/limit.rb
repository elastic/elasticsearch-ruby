# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which limits the number of documents to evaluate
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             limit value: 100
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-limit-filter.html
        #
        class Limit
          include BaseComponent

          option_method :value
        end

      end
    end
  end
end
