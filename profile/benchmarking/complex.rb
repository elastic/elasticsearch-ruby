module Elasticsearch
  module Benchmarking

    # Class encapsulating all settings and functionality for running benchmarking
    #   tests making complex requests.
    #
    # @since 7.0.0
    class Complex
      include Measurable

      # Test sending a bulk request to create a large number of documents.
      #
      # @example Test sending a bulk create request.
      #   Benchmarking::Complex.create_documents(opts)
      #
      # @param [ Hash ] opts The test run options.
      #
      # @since 7.0.0
      def create_documents(opts = {})
        results = with_cleanup do
          slices = dataset_slices
          opts['repetitions'].times.collect do
            Benchmark.realtime do
              slices.each do |slice|
                client.bulk(body: slice)
              end
            end
          end
        end
        res = Results.new(self, results, opts.merge(operation: __method__))
        res.index!(client)[:results]
      end

      # # Test sending a request a search request.
      # #
      # # @example Test sending a search request.
      # #   Benchmarking::Complex.search_documents(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def search_documents(repetitions)
      #   results = with_cleanup(client) do
      #     client.bulk(body: dataset)
      #     query = { match: { publisher: "Random House"} }
      #     request = { index: INDEX, body: { query: query } }
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         client.search(request)
      #       end
      #     end
      #   end
      #   median(results)
      # end
      #
      # def mixed_bulk_small(repetitions)
      #
      # end
      #
      # def mixed_bulk_large(repetitions)
      #
      # end
    end
  end
end
