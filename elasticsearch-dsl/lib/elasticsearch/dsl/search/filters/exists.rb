# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which have a non-`null` value in the specified field
        # (ie. the reverse of the `missing` filter)
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             exists field: 'occupation'
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-exists-filter.html
        #
        class Exists
          include BaseComponent

          option_method :field
        end

      end
    end
  end
end
