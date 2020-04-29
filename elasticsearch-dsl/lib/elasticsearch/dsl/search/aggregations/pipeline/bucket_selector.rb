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

        # A parent pipeline aggregation which executes a script which determines whether the current bucket will be retained in the parent multi-bucket aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :sales_bucket_filter do
        #       bucket_selector buckets_path: { totalSales: 'total_sales' }, script: 'totalSales <= 50'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :sales_bucket_filter do
        #       bucket_selector do
        #         buckets_path totalSales: 'total_sales'
        #         script 'totalSales <= 50'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-bucket-selector-aggregation.html
        #
        class BucketSelector
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :script
          option_method :gap_policy
        end
      end
    end
  end
end
