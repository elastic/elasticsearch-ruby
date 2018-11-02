module Elasticsearch
  module Benchmarking

    # Class encapsulating all settings and functionality for running benchmarking
    #   tests making simple requests.
    #
    # @since 7.0.0
    class Simple

      # Create a Simple request benchmark test.
      #
      # @example Create a test.
      #   Benchmarking::Simple.new(:patron)
      #
      # @param [ Symbol ] adapter The adapter the client should be configured with.
      #
      # @since 7.0.0
      def initialize(adapter = ::Faraday.default_adapter)
        @adapter = adapter
      end

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
      # @example Test sending a create index request.
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

      # Test sending a create document request for a small document.
      #
      # @example Test sending a create document request.
      #   Benchmarking::Simple.create_document_small(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def create_document_small(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(SMALL_DOCUMENT)[0]
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a create document request for a large document.
      #
      # @example Test sending a create document request.
      #   Benchmarking::Simple.create_document_large(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def create_document_large(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(LARGE_DOCUMENT)[0]
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a get document request for a large document.
      #
      # @example Test sending a get document request.
      #   Benchmarking::Simple.get_document_large(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def get_document_large(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(LARGE_DOCUMENT)[0]
          id = client.create(index: INDEX, body: document)['_id']
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.get(index: INDEX, id: id)
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a get document request for a small document.
      #
      # @example Test sending a get document request.
      #   Benchmarking::Simple.get_document_small(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def get_document_small(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(SMALL_DOCUMENT)[0]
          id = client.create(index: INDEX, body: document)['_id']
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.get(index: INDEX, id: id)
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a search request and retrieving a large document.
      #
      # @example Test sending a search request for a large document.
      #   Benchmarking::Simple.search_document_large(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def search_document_large(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(LARGE_DOCUMENT)[0]
          client.create(index: INDEX, body: document)
          search_criteria = document.find { |k,v| k != 'id' && v.is_a?(String) }
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.search(index: INDEX,
                              body: { query: { match: { search_criteria[0] => search_criteria[1] } } })
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a search request and retrieving a small document.
      #
      # @example Test sending a search request for a small document.
      #   Benchmarking::Simple.search_document_small(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def search_document_small(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(SMALL_DOCUMENT)[0]
          client.create(index: INDEX, body: document)
          search_criteria = document.find { |k,v| k != 'id' && v.is_a?(String) }
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.search(index: INDEX,
                              body: { query: { match: { search_criteria[0] => search_criteria[1] } } })
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      # Test sending a update request for a small document.
      #
      # @example Test sending an update request for a small document.
      #   Benchmarking::Simple.update_document(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def update_document(repetitions)
        results = Benchmarking.with_cleanup(client) do
          document = Benchmarking.load_json_from_file(SMALL_DOCUMENT)[0]
          id = client.create(index: INDEX, body: document)['_id']
          field = document.find { |k,v| k != 'id' && v.is_a?(String) }.first
          repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do |i|
                client.update(index: INDEX,
                              id: id,
                              body: { doc: { field:  "#{document[field]}-#{i}" } })
              end
            end
          end
        end
        Benchmarking.median(results)
      end

      private

      def client
        @client ||= Elasticsearch::Transport::Client.new(host: ELASTICSEARCH_URL,
                                                         adapter: @adapter,
                                                         tracer: nil)
      end
    end
  end
end
