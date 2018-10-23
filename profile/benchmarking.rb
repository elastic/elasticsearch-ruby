require 'benchmark'
require 'elasticsearch'
require 'elasticsearch-api'
require 'elasticsearch-transport'
require_relative 'benchmarking/helper'
require_relative 'benchmarking/simple'

module Elasticsearch

    # Module with all functionality for running client transport benchmark tests.
    #
    # @since 7.0.0
    module Benchmarking

      extend self

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
      DATA_PATH = [CURRENT_PATH, 'benchmarking', 'data'].join('/').freeze

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
    end
end