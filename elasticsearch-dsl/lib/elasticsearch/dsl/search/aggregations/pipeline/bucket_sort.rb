# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

        # A parent pipeline aggregation which sorts the buckets of its parent multi-bucket aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :sales_bucket_filter do
        #       bucket_sort gap_policy: 'insert_zero'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :sales_bucket_sort do
        #       bucket_sort do
        #         sort do
        #           by :total_sales, order: 'desc'
        #         end
        #         size 3
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-bucket-sort-aggregation.html
        #
        class BucketSort
          include BaseAggregationComponent

          def sort(*args, &block)
            if !args.empty? || block
              @sort = Sort.new(*args, &block)
              self
            else
              @sort
            end
          end

          def to_hash
            call

            if @aggregations
              @hash[:aggregations] = @aggregations.to_hash
            end

            @hash[name].merge!(sort: @sort.to_hash) if @sort
            @hash
          end

          option_method :from
          option_method :size
          option_method :gap_policy
        end
      end
    end
  end
end
