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

module Elasticsearch

  # Module with all functionality for running client transport benchmark tests.
  #
  # @since 7.0.0
  module Benchmarking

    extend self

    def each_run(file)
      file = File.new(file)
      matrix = YAML.load(ERB.new(file.read).result)
      file.close

      matrix.each do |run|
        run['repetitions'] ||= 10
        run['metrics'] ||= ['mean']
        yield(run)
      end
    end
  end
end
