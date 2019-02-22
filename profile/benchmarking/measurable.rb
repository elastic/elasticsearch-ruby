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

module Elasticsearch

  module Benchmarking
    # Helper functions used by benchmarking tasks
    module Measurable

      attr_reader :options
      attr_reader :client_adapter

      # The default number of measured repetitions.
      #
      # @since 7.0.0
      DEFAULT_MEASURED_REPETITIONS = 5

      # The default number of warmup repetitions.
      #
      # @since 7.0.0
      DEFAULT_WARMUP_REPETITIONS = 1

      # The default number of action iterations.
      #
      # @since 7.0.0
      DEFAULT_ACTION_ITERATIONS = 1

      # Create a benchmark test.
      #
      # @example Create a test.
      #   Benchmarking::Simple.new({ 'repetitions' => { 'warmup' => 1 }}, :patron)
      #
      # @param [ Hash ] options The options for the benchmarking task.
      # @param [ Symbol ] adapter The adapter the client should be configured with.
      #
      # @since 7.0.0
      def initialize(options = {}, adapter = ::Faraday.default_adapter)
        @options = options
        @client_adapter = adapter
      end

      # Run a benchmark test.
      #
      # @example Run a test.
      #   task.run(:ping)
      #
      # @param [ Symbol ] type The name of the test to run.
      #
      # @return [ Hash ] The test results document.
      #
      # @since 7.0.0
      def run(type, opts={})
        send(type, opts)
      end

      # Get the nodes info on the elasticsearch server used for the benchmarking tests.
      #
      # @example Get the nodes info.
      #   task.nodes_info
      #
      # @return [ Hash ] The nodes info.
      #
      # @since 7.0.0
      def nodes_info
        client.nodes.info(os: true)
      end

      # Get the version of the elasticsearch server used for the benchmarking tests.
      #
      # @example Get the server version.
      #   task.server_version
      #
      # @return [ String ] The server version.
      #
      # @since 7.0.0
      def server_version
        client.perform_request('GET', '/').body['version']['number']
      end

      # Get the description of the benchmarking task.
      #
      # @example Get the task description.
      #   task.description
      #
      # @return [ String ] The task description.
      #
      # @since 7.0.0
      def description
        @options['description']
      end

      # Get number of measured repetitions.
      #
      # @example Get the number of measured repetitions.
      #   task.measured_repetitions
      #
      # @return [ Numeric ] The number of measured repetitions.
      #
      # @since 7.0.0
      def measured_repetitions
        @options['repetitions']['measured'] || DEFAULT_MEASURED_REPETITIONS
      end

      # Get number of warmup repetitions.
      #
      # @example Get the number of warmup repetitions.
      #   task.warmup_repetitions
      #
      # @return [ Numeric ] The number of warmup repetitions.
      #
      # @since 7.0.0
      def warmup_repetitions
        @options['repetitions']['warmup'] || DEFAULT_WARMUP_REPETITIONS
      end

      # Get number of iterations of the action.
      #
      # @example Get the number of iterations of the action.
      #   task.action_iterations
      #
      # @return [ Numeric ] The number of action iterations.
      #
      # @since 7.0.0
      def action_iterations
        @options['repetitions']['action_iterations'] || DEFAULT_ACTION_ITERATIONS
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
      DATASET_FILE = [DATA_PATH, 'documents-small.json'].join('/').freeze

      # The name of the index to use for benchmark tests.
      #
      # @return [ String ] The index to use for benchmarking tests.
      #
      # @since 7.0.0
      INDEX = 'benchmarking-ruby'.freeze

      def load_json_from_file(file_name)
        File.open(file_name, "r") do |f|
          f.each_line.collect do |line|
            JSON.parse(line)
          end
        end
      end

      def with_cleanup
        client.indices.delete(index: 'benchmarking-*')
        client.indices.create(index: INDEX) unless client.indices.exists?(index: INDEX)
        results = yield
        client.indices.delete(index: 'benchmarking-*')
        results
      end

      def client
        @client ||= Elasticsearch::Transport::Client.new(host: ELASTICSEARCH_URL,
                                                         adapter: adapter,
                                                         tracer: nil)
      end

      def dataset_slices(slice_size=10000)
        @dataset_slices ||= begin
          dataset.collect do |d|
            { index: { _index: INDEX, _type: '_doc', data: d } }
          end.each_slice(slice_size)
        end
      end

      def dataset
        @dataset ||= load_json_from_file(DATASET_FILE)
      end

      def small_document
        @small_document ||= load_json_from_file(SMALL_DOCUMENT)[0]
      end

      def large_document
        @large_document ||= load_json_from_file(LARGE_DOCUMENT)[0]
      end

      def noop_plugin?
        false
      end

      private

      def index_results!(results, options = {})
        res = Results.new(self, results, options)
        (doc = res.index!(client)) && doc[:results]
      end
    end
  end
end
