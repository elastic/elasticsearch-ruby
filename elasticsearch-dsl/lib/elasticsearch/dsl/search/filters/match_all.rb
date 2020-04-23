# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which matches on all documents
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             match_all
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-all-filter.html
        #
        class MatchAll
          include BaseComponent
        end

      end
    end
  end
end
