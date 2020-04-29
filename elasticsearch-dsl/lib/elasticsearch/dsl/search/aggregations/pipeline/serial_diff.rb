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

        # Serial differencing is a technique where values in a time series are subtracted from itself at different time lags or periods.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :thirtieth_difference do
        #       serial_diff buckets_path: 'the_sum'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :thirtieth_difference do
        #       serial_diff do
        #         buckets_path 'the_sum'
        #         lag 30
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-serialdiff-aggregation.html
        #
        class SerialDiff
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :lag
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
