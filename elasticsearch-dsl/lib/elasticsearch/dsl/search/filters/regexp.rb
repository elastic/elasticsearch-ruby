# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching the specified regular expression
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             regexp :path do
        #               value '^/usr/?.*/var'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-filter.html
        #
        class Regexp
          include BaseComponent

          option_method :value
          option_method :flags
        end

      end
    end
  end
end
