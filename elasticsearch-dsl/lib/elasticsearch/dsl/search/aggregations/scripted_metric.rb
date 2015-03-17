module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A metric aggregation which uses scripts for the computation
        #
        # @example
        #
        #     search do
        #       aggregation :clicks_for_one do
        #         scripted_metric do
        #           init_script "_agg['transactions'] = []"
        #           map_script  "if (doc['tags'].value.contains('one')) { _agg.transactions.add(doc['clicks'].value) }"
        #           combine_script "sum = 0; for (t in _agg.transactions) { sum += t }; return sum"
        #           reduce_script "sum = 0; for (a in _aggs) { sum += a }; return sum"
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-scripted-metric-aggregation.html
        #
        # See the integration test for a full example.
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
