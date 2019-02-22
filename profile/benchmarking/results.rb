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

    # Class encapsulating formatting and indexing the results from a benchmarking run.
    #
    # @since 7.0.0
    class Results

      attr_reader :raw_results

      # Create a Results object.
      #
      # @example Create a results object.
      #   Benchmarking::Results.new(task, [...], options)
      #
      # @param [ Elasticsearch::Benchmarking ] task The task that executed the benchmarking run.
      # @param [ Array<Fixnum> ] results An array of the results.
      # @param [ Hash ] options The options.
      #
      # @since 7.0.0
      def initialize(task, results, options = {})
        @task = task
        @raw_results = results.map { |r| r * 1000 }
        @options = options
      end

      # Index the results document into elasticsearch.
      #
      # @example Index the results.
      #   results.index!(client)
      #
      # @param [ Elasticsearch::Client ] client The client to use to index the results.
      #
      # @since 7.0.0
      def index!(client)
        create_index!(client)
        #client.index(index: index_name, body: results_doc)
        puts results_doc
      end

      private

      attr_reader :options

      DEFAULT_INDEX_NAME = 'benchmarking_results'.freeze

      DEFAULT_METRICS = ['median'].freeze

      CLIENT_NAME = 'elasticsearch-ruby-client'.freeze

      COMPLEXITIES = { Elasticsearch::Benchmarking::Simple => :simple,
                       Elasticsearch::Benchmarking::Complex => :complex }.freeze

      def action_iterations
        options[:action_iterations]
      end

      def index_name
        options[:index_name] || DEFAULT_INDEX_NAME
      end

      def create_index!(client)
        unless client.indices.exists?(index: index_name)
          client.indices.create(index: index_name)
        end
      end

      def results_doc
        @results_doc ||= begin
          { '@timestamp' => Time.now.iso8601,
            event: event_doc,
            agent: agent_doc,
            server: server_doc }
        end
      end

      def event_doc
        { description: description,
          category: category,
          action: action,
          duration: duration,
          stastistics: statistics_doc,
          repetitions: repetitions_doc }.tap do |doc|
            doc.merge!(dataset: dataset,
                       dataset_details: dataset_details) if dataset
        end
      end

      def description
        @task.description
      end

      def category
        COMPLEXITIES[@task.class]
      end

      def action
        @options[:operation]
      end


      def dataset
        @options[:dataset]
      end

      def dataset_details
        { size: @options[:dataset_size],
          num_documents: @options[:dataset_n_documents] }
      end

      def duration
        @options[:duration]
      end

      def statistics_doc
        { mean: mean,
          median: median,
          max: max,
          min: min,
          standard_deviation: standard_deviation
        }
      end

      def median
        raw_results.sort![raw_results.size / 2 - 1]
      end

      def mean
        raw_results.inject { |sum, el| sum + el }.to_f / raw_results.size
      end

      def max
        raw_results.max
      end

      def min
        raw_results.min
      end

      def standard_deviation
        Math.sqrt(sample_variance)
      end

      def sample_variance
        m = mean
        sum = raw_results.inject(0) { |sum, i| sum +(i-m)**2 }
        sum/(raw_results.length - 1).to_f
      end

      def repetitions_doc
        { warmup: @task.warmup_repetitions,
          measured: @task.measured_repetitions,
          iterations: action_iterations }
      end

      def agent_doc
        { version: Elasticsearch::VERSION,
          name: CLIENT_NAME,
          git: git_doc,
          language: language_doc,
          os: client_os_doc,
          adapter: adapter }
      end

      def adapter
        @task.client_adapter
      end

      def git_doc
        sha = `git rev-parse HEAD`
        branch = `git branch | grep \\* | cut -d ' ' -f2`
        commit_message = `git log -1 --pretty=%B`
        repository = 'elasticsearch-ruby'

        { branch: branch.chomp,
          sha: sha.chomp,
          commit_message: commit_message.chomp,
          repository: repository.chomp }
      end

      def language_doc
        version = [
            RUBY_VERSION,
            RUBY_PLATFORM,
            RbConfig::CONFIG['build']
        ].compact.join(', ')
        { runtime_version: version }
      end

      def client_os_doc
        { platform: platform,
          type: type,
          architecture: architecture }
      end

      def type
        (RbConfig::CONFIG && RbConfig::CONFIG['host_os']) ?
            RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase : 'unknown'
      end

      def architecture
        RbConfig::CONFIG['target_cpu']
      end

      def platform
        [
            @platform,
            RUBY_VERSION,
            RUBY_PLATFORM,
            RbConfig::CONFIG['build']
        ].compact.join(', ')
      end

      def server_doc
        { version: @task.server_version,
          nodes_info: @task.nodes_info }
      end
    end
  end
end
