module Elasticsearch
  # Helper functions used by benchmarking tasks
  module Measurable

    private

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
    DATASET = [DATA_PATH, 'nytimes-best-sellers.json'].join('/').freeze

    # The name of the index to use for benchmark tests.
    #
    # @return [ String ] The index to use for benchmarking tests.
    #
    # @since 7.0.0
    INDEX = 'benchmarking-ruby'.freeze

    # The default number of test repetitions.
    #
    # @return [ Integer ] The number of test repetitions.
    #
    # @since 7.0.0
    TEST_REPETITIONS = 10.freeze

    # The number of default warmup repetitions of the test to do before
    # recording times.
    #
    # @return [ Integer ] The default number of warmup repetitions.
    #
    # @since 7.0.0
    WARMUP_REPETITIONS = 5.freeze

    # Load a json file and represent each document as a Hash.
    #
    # @example Load a file.
    #   Benchmarking.load_file(file_name)
    #
    # @param [ String ] The file name.
    #
    # @return [ Array ] A list of json documents.
    #
    # @since 7.0.0
    def load_json_from_file(file_name)
      File.open(file_name, "r") do |f|
        f.each_line.collect do |line|
          JSON.parse(line)
        end
      end
    end

    # Get the median of values in a list.
    #
    # @example Get the median.
    #   Benchmarking.median(values)
    #
    # @param [ Array ] values The values to get the median of.
    #
    # @return [ Numeric ] The median of the list.
    #
    # @since 7.0.0
    def median(values)
      values.sort![values.size / 2 - 1]
    end
    alias :mean :median
    alias :max :median
    alias :min :median

    # Delete, then create an index for a test. Yield to the block and then
    #   delete the index after.
    #
    # @example Clean before and cleanup after a test.
    #   Benchmarking.with_cleanup(client) { ... }
    #
    # @param [ Elasticsearch::Client ] client The client to use when performing
    #   index creation and cleanup.
    #
    # @since 7.0.0
    def with_cleanup
      client.indices.delete(index: '_all')
      client.indices.create(index: INDEX)
      results = yield
      client.indices.delete(index: '_all')
      results
    end

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

    def small_document
      load_json_from_file(SMALL_DOCUMENT)[0]
    end

    def large_document
      load_json_from_file(LARGE_DOCUMENT)[0]
    end
  end
end
