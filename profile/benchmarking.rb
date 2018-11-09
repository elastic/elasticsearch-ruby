require 'benchmark'
require 'yaml'
require 'erb'
require 'elasticsearch'
require 'elasticsearch-api'
require 'elasticsearch-transport'
require 'json'
require_relative 'benchmarking/measurable'
require_relative 'benchmarking/simple'
require_relative 'benchmarking/complex'
require_relative 'benchmarking/results'

module Elasticsearch

  # Module with all functionality for running client benchmark tests.
  #
  # @since 7.0.0
  module Benchmarking

    extend self

    # The default number of test repetitions.
    #
    # @return [ Integer ] The number of test repetitions.
    #
    # @since 7.0.0
    TEST_REPETITIONS = 10.freeze

    # The default definition of a test run.
    #
    # @return [ Hash ] The default test run definition.
    #
    # @since 7.0.0
    DEFAULT_RUN = { 'repetitions' => TEST_REPETITIONS,
                    'name' => 'default',
                    'metrics' => ['mean'] }.freeze

    # Parse a file of run definitions and yield each run.
    #
    # @params [ String ] file The YAML file containing the matrix of test run definitions.
    #
    # @yieldparam [ Hash ] A test run definition.
    #
    # @since 7.0.0
    def each_run(file)
      if file
        file = File.new(file)
        matrix = YAML.load(ERB.new(file.read).result)
        file.close

        matrix.each_with_index do |run, i|
          DEFAULT_RUN.merge(run)
          yield(run, i)
        end
      else
        yield(DEFAULT_RUN)
      end
    end
  end
end
