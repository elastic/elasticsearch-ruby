# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'benchmark'
require 'yaml'
require 'erb'
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
    DEFAULT_TEST_REPETITIONS = 10.freeze

    # The number of default warmup repetitions of the test to do before
    # recording times.
    #
    # @return [ Integer ] The default number of warmup repetitions.
    #
    # @since 7.0.0
    DEFAULT_WARMUP_REPETITIONS = 1.freeze

    # The default definition of a test run.
    #
    # @return [ Hash ] The default test run definition.
    #
    # @since 7.0.0
    DEFAULT_RUN = { 'description' => 'Default run',
                    'repetitions' => {
                      'measured' => DEFAULT_TEST_REPETITIONS,
                      'warmup' => DEFAULT_WARMUP_REPETITIONS },
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
