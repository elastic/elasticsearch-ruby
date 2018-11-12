module Elasticsearch
  module Benchmarking

    # Class encapsulating all settings and functionality for running benchmarking
    #   tests making simple requests.
    #
    # @since 7.0.0
    class Simple
      include Measurable

      # Test sending a ping request.
      #
      # @example Test sending a ping request.
      #   Benchmarking::Simple.ping(opts)
      #
      # @param [ Hash ] opts The test run options.
      #
      # @since 7.0.0
      def ping(opts = {})
        results = opts['repetitions'].times.collect do
          Benchmark.realtime do
            1_000.times do
              client.ping
            end
          end
        end
        res = Results.new(self, results, opts.merge(operation: __method__))
        res.index!(client)[:results]
      end

      # Test sending a create_index request.
      #
      # @example Test sending a create index request.
      #   Benchmarking::Simple.create_index(opts)
      #
      # @param [ Hash ] opts The test run options.
      #
      # @since 7.0.0
      def create_index(opts={})
        results = with_cleanup do
          opts['repetitions'].times.collect do
            Benchmark.realtime do
              20.times do
                client.indices.create(index: "test-#{Time.now.to_f}")
              end
            end
          end
        end
        res = Results.new(self, results, opts.merge(operation: __method__))
        res.index!(client)[:results]
      end
      #
      # # Test sending a create document request for a small document.
      # #
      # # @example Test sending a create document request.
      # #   Benchmarking::Simple.create_document_small(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def create_document_small(repetitions, opts={})
      #   results = with_cleanup do
      #     document = small_document
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         1_000.times do
      #           client.create(index: INDEX, body: document)
      #         end
      #       end
      #     end
      #   end
      #   median(results)
      # end
      #
      # Test sending a create document request for a large document.
      #
      # @example Test sending a create document request.
      #   Benchmarking::Simple.create_document_large(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def create_document_large(opts={})
        document = large_document
        results = with_cleanup do
          opts['repetitions'].times.collect do
            Benchmark.realtime do
              1_000.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
        end
        res = Results.new(self, results, opts.merge(operation: __method__))
        res.index!(client)[:results]
      end
      #
      # # Test sending a get document request for a large document.
      # #
      # # @example Test sending a get document request.
      # #   Benchmarking::Simple.get_document_large(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def get_document_large(repetitions, opts={})
      #   results = with_cleanup do
      #     id = client.create(index: INDEX, body: large_document)['_id']
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         1_000.times do
      #           client.get(index: INDEX, id: id)
      #         end
      #       end
      #     end
      #   end
      #   median(results)
      # end
      #
      # # Test sending a get document request for a small document.
      # #
      # # @example Test sending a get document request.
      # #   Benchmarking::Simple.get_document_small(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def get_document_small(repetitions, opts={})
      #   results = with_cleanup do
      #     id = client.create(index: INDEX, body: small_document)['_id']
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         1_000.times do
      #           client.get(index: INDEX, id: id)
      #         end
      #       end
      #     end
      #   end
      #   median(results)
      # end
      #
      # # Test sending a search request and retrieving a large document.
      # #
      # # @example Test sending a search request for a large document.
      # #   Benchmarking::Simple.search_document_large(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def search_document_large(repetitions, opts={})
      #   results = with_cleanup do
      #     client.create(index: INDEX, body: large_document)
      #     search_criteria = large_document.find { |k,v| k != 'id' && v.is_a?(String) }
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         1_000.times do
      #           client.search(index: INDEX,
      #                         body: { query: { match: { search_criteria[0] => search_criteria[1] } } })
      #         end
      #       end
      #     end
      #   end
      #   median(results)
      # end
      #
      # # Test sending a search request and retrieving a small document.
      # #
      # # @example Test sending a search request for a small document.
      # #   Benchmarking::Simple.search_document_small(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def search_document_small(repetitions, opts={})
      #   results = with_cleanup do
      #     client.create(index: INDEX, body: small_document)
      #     search_criteria = small_document.find { |k,v| k != 'id' && v.is_a?(String) }
      #     request = { body: { query: { match: { search_criteria[0] => search_criteria[1] } } } }
      #     if opts[:noop]
      #       Elasticsearch::API.const_set('UNDERSCORE_SEARCH', '_noop_search')
      #     else
      #       request.merge!(index: INDEX)
      #     end
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         1_000.times do
      #           client.search(request)
      #         end
      #       end
      #     end
      #   end
      #   median(results)
      # end
      #
      # # Test sending a update request for a small document.
      # #
      # # @example Test sending an update request for a small document.
      # #   Benchmarking::Simple.update_document(10)
      # #
      # # @param [ Integer ] repetitions The number of test repetitions.
      # #
      # # @since 7.0.0
      # def update_document(repetitions, opts={})
      #   results = with_cleanup do
      #     document = small_document
      #     id = client.create(index: INDEX, body: document)['_id']
      #     field = document.find { |k,v| k != 'id' && v.is_a?(String) }.first
      #     repetitions.times.collect do
      #       Benchmark.realtime do
      #         1_000.times do |i|
      #           client.update(index: INDEX,
      #                         id: id,
      #                         body: { doc: { field:  "#{document[field]}-#{i}" } })
      #         end
      #       end
      #     end
      #   end
      #   median(results)
      # end
    end
  end
end
