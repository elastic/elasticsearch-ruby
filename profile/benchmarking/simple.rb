module Elasticsearch
  module Benchmarking

    #
    #
    # @since 7.0.0
    module Simple

      extend self

      # Run a Simple request benchmark test.
      #
      # @example Run a test.
      #   Benchmarking::Simple.run(:ping)
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

      # Test sending a ping request.
      #
      # @example Test sending a ping request.
      #   Benchmarking::Simple.ping(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def ping(repetitions)
        results = repetitions.times.collect do
          Benchmark.realtime do
            1_000.times do
              client.ping
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a create_index request.
      #
      # @example Test sending a ping request.
      #   Benchmarking::Simple.create_index(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def create_index(repetitions)
        client.indices.delete(index: '_all')
        results = repetitions.times.collect do
          Benchmark.realtime do
            20.times do
              client.indices.create(index: "test-#{Time.now.to_f}")
            end
          end
        end
        client.indices.delete(index: '_all')
        Benchmarking.median(results)
      end

      def create_document_small(repetitions)

      end

      def create_document_large(repetitions)

      end

      def get_document(repetitions)

      end

      def update_document(repetitions)

      end

      def delete_document(repetitions)

      end

      private

      def client
        @client ||= Elasticsearch::Transport::Client.new(host: ELASTICSEARCH_URL, tracer: nil)
      end
    end
  end
end