module Elasticsearch
  module Benchmarking

    # Class encapsulating all settings and functionality for running benchmarking
    #   tests making complex requests.
    #
    # @since 7.0.0
    class Complex

      # Create a Complex request benchmark test.
      #
      # @example Create a test.
      #   Benchmarking::Complex.new(:patron)
      #
      # @param [ Symbol ] adapter The adapter the client should be configured with.
      #
      # @since 7.0.0
      def initialize(adapter = ::Faraday.default_adapter)
        @adapter = adapter
      end

      # Run a Complex request benchmark test.
      #
      # @example Run a test.
      #   Benchmarking::Complex.run(:ping)
      #
      # @param [ Symbol ] type The name of the test to run.
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @return [ Numeric ] The test results.
      #
      # @since 7.0.0
      def run(type, repetitions = TEST_REPETITIONS)
        puts "#{type} : #{send(type, repetitions)}"
      end

      # Test sending a bulk request to create a large number of documents.
      #
      # @example Test sending a bulk create request.
      #   Benchmarking::Complex.create_documents(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def create_documents(repetitions)
        results = Benchmarking.with_cleanup(client) do
          repetitions.times.collect do
            Benchmark.realtime do
              client.bulk(body: dataset)
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a request a search request.
      #
      # @example Test sending a search request.
      #   Benchmarking::Complex.search_documents(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def search_documents(repetitions)
        results = Benchmarking.with_cleanup(client) do
          client.bulk(body: dataset)
          query = { match: { publisher: "Random House"} }
          request = { index: INDEX, body: { query: query } }
          repetitions.times.collect do
            Benchmark.realtime do
              client.search(request)
            end
          end
        end
        Benchmarking.median(results)
      end

      def mixed_bulk_small(repetitions)

      end

      def mixed_bulk_large(repetitions)

      end

      private

      def client
        @client ||= Elasticsearch::Transport::Client.new(host: ELASTICSEARCH_URL,
                                                         adapter: @adapter,
                                                         tracer: nil)
      end

      def dataset
        @dataset ||= begin
          Benchmarking.load_json_from_file(DATASET).collect do |d|
            d.delete('_id')
            { index:  { _index: INDEX, _type: '_doc', data: d } }
          end
        end
      end
    end
  end
end
