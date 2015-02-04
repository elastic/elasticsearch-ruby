module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # ScriptedMetric agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-scripted-metric-aggregation.html
        #
        class ScriptedMetric
          include BaseComponent

          option_method :init_script
          option_method :map_script
          option_method :combine_script
          option_method :reduce_script
          option_method :params
          option_method :lang
        end

      end
    end
  end
end
