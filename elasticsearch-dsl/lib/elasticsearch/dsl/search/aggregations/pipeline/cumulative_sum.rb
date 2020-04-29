# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which calculates the cumulative sum of a specified metric in a parent histogram (or date_histogram) aggregation. 
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :cumulative_sales do
        #       cumulative_sum buckets_path: 'sales'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :cumulative_sales do
        #       cumulative_sum do
        #         buckets_path 'sales'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-cumulative-sum-aggregation.html
        #
        class CumulativeSum
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :format
        end
      end
    end
  end
end
