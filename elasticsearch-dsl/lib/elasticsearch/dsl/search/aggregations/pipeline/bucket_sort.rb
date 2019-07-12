# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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

          # Add a sort clause to the search definition.
          #
          # @example
          #
          #   bucket_sort do
          #     sort do
          #       by :total_sales, order: 'desc'
          #     end
          #   end
          #
          # @return [ Sort, Hash ] The sort definition.
          #
          # @since 0.1.9
          def sort(*args, &block)
            if !args.empty? || block
              @sort = Sort.new(*args, &block)
              self
            else
              @sort
            end
          end

          # Get a hash representation of the aggregation.
          #
          # @example
          #
          #   s = search do
          #     aggregation do
          #       bucket_sort do
          #         sort do
          #           by :total_sales, order: 'desc'
          #         end
          #       end
          #     end
          #   end
          #
          # client.search(body: s.to_hash)
          #
          # @return [ Hash ] The hash representation of the aggregation.
          #
          # @since 0.1.9
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
