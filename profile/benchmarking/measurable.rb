module Elasticsearch

  module Benchmarking
    # Helper functions used by benchmarking tasks
    module Measurable

      # Create a benchmark test.
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

      # Run a benchmark test.
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
      def run(type, opts={})
        send(type, opts)
      end

      private

      attr_reader :adapter

      # The elasticsearch url to use for the tests.
      #
      # @return [ String ] The Elasticsearch URL to use in tests.
      #
      # @since 7.0.0
      ELASTICSEARCH_URL = ENV['ELASTICSEARCH_URL'] || "localhost:#{(ENV['TEST_CLUSTER_PORT'] || 9200)}"

      # The current path.
      #
      # @return [ String ] The current path.
      #
      # @since 7.0.0
      CURRENT_PATH = File.expand_path(File.dirname(__FILE__)).freeze

      # The path to data files used in Benchmarking tests.
      #
      # @return [ String ] Path to Benchmarking test files.
      #
      # @since 7.0.0
      DATA_PATH = [CURRENT_PATH, 'data'].join('/').freeze

      # The file path and name for the small document.
      #
      # @return [ String ] The file path and name for the small document.
      #
      # @since 7.0.0
      SMALL_DOCUMENT = [DATA_PATH, 'smalldoc.json'].join('/').freeze

      # The file path and name for the large document.
      #
      # @return [ String ] The file path and name for the large document.
      #
      # @since 7.0.0
      LARGE_DOCUMENT = [DATA_PATH, 'largedoc.json'].join('/').freeze

      # The file path and name for the dataset.
      #
      # @return [ String ] The file path and name for the dataset.
      #
      # @since 7.0.0
      DATASET = [DATA_PATH, 'documents-small.json'].join('/').freeze

      # The name of the index to use for benchmark tests.
      #
      # @return [ String ] The index to use for benchmarking tests.
      #
      # @since 7.0.0
      INDEX = 'benchmarking-ruby'.freeze

      # The number of default warmup repetitions of the test to do before
      # recording times.
      #
      # @return [ Integer ] The default number of warmup repetitions.
      #
      # @since 7.0.0
      WARMUP_REPETITIONS = 5.freeze

      def load_json_from_file(file_name)
        File.open(file_name, "r") do |f|
          f.each_line.collect do |line|
            JSON.parse(line)
          end
        end
      end

      def with_cleanup
        client.indices.delete(index: 'test-*')
        client.indices.create(index: INDEX) unless client.indices.exists?(index: INDEX)
        results = yield
        client.indices.delete(index: 'test-*')
        results
      end

      def client
        @client ||= Elasticsearch::Transport::Client.new(host: ELASTICSEARCH_URL,
                                                         adapter: adapter,
                                                         tracer: nil)
      end

      def dataset_slices(slice_size=10000)
        @dataset_slices ||= begin
          load_json_from_file(DATASET).collect do |d|
            { index: { _index: INDEX, _type: '_doc', data: d } }
          end.each_slice(slice_size)
        end
      end

      def small_document
        load_json_from_file(SMALL_DOCUMENT)[0]
      end

      def large_document
        load_json_from_file(LARGE_DOCUMENT)[0]
      end
    end
  end
end
