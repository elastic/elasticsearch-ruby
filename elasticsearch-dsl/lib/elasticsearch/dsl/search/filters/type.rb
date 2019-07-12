# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching the specified type
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             type do
        #               value 'article'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-type-filter.html
        #
        class Type
          include BaseComponent

          option_method :value
        end

      end
    end
  end
end
