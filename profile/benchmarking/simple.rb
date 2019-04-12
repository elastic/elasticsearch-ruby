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

require 'objspace'

module Elasticsearch
  module Benchmarking

    # Class encapsulating all settings and functionality for running benchmarking
    #   tasks making simple requests.
    #
    # @since 7.0.0
    class Simple
      include Measurable

      # Test sending a ping request.
      #
      # @example Test sending a ping request.
      #   task.ping(opts)
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results document.
      #
      # @since 7.0.0
      def ping(opts = {})
        start = 0
        end_time = 0
        results = []
        action_iterations = 1_000

        warmup_repetitions.times { client.ping }

        start = current_time
        results = measured_repetitions.times.collect do
          Benchmark.realtime do
            action_iterations.times do
              client.ping
            end
          end
        end
        end_time = current_time

        options = { duration: end_time - start,
                    operation: __method__,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending a create_index request.
      #
      # @example Test sending a create index request.
      #   task.create_index(opts)
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results document.
      #
      # @since 7.0.0
      def create_index(opts = {})
        start = 0
        end_time = 0
        results = []
        action_iterations = 10

        warmup_repetitions.times do
          client.indices.create(index: "benchmarking-#{Time.now.to_f}")
        end

        with_cleanup do
          start = current_time
          results = measured_repetitions.times.collect do |i|
            index_names = action_iterations.times.collect { |j| (measured_repetitions*i) + j }
            Benchmark.realtime do
              action_iterations.times do |j|
                client.indices.create(index: "benchmarking-#{index_names[j]}")
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending an index document request for a small document.
      #
      # @example Test sending an index document request.
      #   task.index_document_small
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results document.
      #
      # @since 7.0.0
      def index_document_small(opts={})
        start = 0
        end_time = 0
        results = []
        document = small_document
        action_iterations = 10

        warmup_repetitions.times do
          client.create(index: INDEX, body: document)
        end

        with_cleanup do
          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending an index document request for a large document.
      #
      # @example Test sending an index document request.
      #   task.index_document_large
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results document.
      #
      # @since 7.0.0
      def index_document_large(opts={})
        start = 0
        end_time = 0
        results = []
        document = large_document
        action_iterations = 1_000

        warmup_repetitions.times do
          client.create(index: INDEX, body: document)
        end

        with_cleanup do
          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'large_document',
                    dataset_size: ObjectSpace.memsize_of(large_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending a get document request for a small document.
      #
      # @example Test sending a get document request.
      #   Benchmarking::Simple.get_document_small
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results document.
      #
      # @since 7.0.0
      def get_document_small(opts={})
        start = 0
        end_time = 0
        results = []
        action_iterations = 1_000

        with_cleanup do
          id = client.create(index: INDEX, body: small_document)['_id']
          warmup_repetitions.times do
            client.get(index: INDEX, id: id)
          end

          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do
                client.get(index: INDEX, id: id)
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending a get document request for a large document.
      #
      # @example Test sending a get document request.
      #   Benchmarking::Simple.get_document_large
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results document.
      #
      # @since 7.0.0
      def get_document_large(opts={})
        start = 0
        end_time = 0
        results = []
        action_iterations = 1_000

        with_cleanup do
          id = client.create(index: INDEX, body: large_document)['_id']
          warmup_repetitions.times do
            client.get(index: INDEX, id: id)
          end

          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do
                client.get(index: INDEX, id: id)
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'large_document',
                    dataset_size: ObjectSpace.memsize_of(large_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending a search request and retrieving a small document.
      #
      # @example Test sending a search request for a small document.
      #   task.search_document_small
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results documents.
      #
      # @since 7.0.0
      def search_document_small(opts={})
        start = 0
        end_time = 0
        results = []
        action_iterations = 1_000

        with_cleanup do
          client.create(index: INDEX, body: small_document)
          search_criteria = { match: { cuisine: 'mexican' } }
          request = { body: { query: search_criteria } }
          if noop_plugin?
            Elasticsearch::API.const_set('UNDERSCORE_SEARCH', '_noop_search')
          else
            request.merge!(index: INDEX)
          end

          warmup_repetitions.times do
            client.search(request)
          end

          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do
                client.search(request)
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending a search request and retrieving a large document.
      #
      # @example Test sending a search request for a large document.
      #   task.search_document_large
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results documents.
      #
      # @since 7.0.0
      def search_document_large(opts={})
        start = 0
        end_time = 0
        results = []
        action_iterations = 1_000

        with_cleanup do
          client.create(index: INDEX, body: large_document)
          search_criteria = { match: { 'user.lang': 'en' } }
          request = { body: { query: search_criteria } }
          if noop_plugin?
            Elasticsearch::API.const_set('UNDERSCORE_SEARCH', '_noop_search')
          else
            request.merge!(index: INDEX)
          end
          warmup_repetitions.times do
            client.search(request)
          end

          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do
                client.search(request)
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'large_document',
                    dataset_size: ObjectSpace.memsize_of(large_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end

      # Test sending a update request for a small document.
      #
      # @example Test sending an update request for a small document.
      #   Benchmarking::Simple.update_document
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results documents.
      #
      # @since 7.0.0
      def update_document(opts={})
        start = 0
        end_time = 0
        results = []
        action_iterations = 1_000

        with_cleanup do
          document = small_document
          id = client.create(index: INDEX, body: document)['_id']
          field = document.find { |k,v| k != 'id' && v.is_a?(String) }.first

          warmup_repetitions.times do |i|
            client.update(index: INDEX,
                          id: id,
                          body: { doc: { field:  "#{document[field]}-#{i}" } })
          end

          start = current_time
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              action_iterations.times do |i|
                client.update(index: INDEX,
                              id: id,
                              body: { doc: { field:  "#{document[field]}-#{i}" } })
              end
            end
          end
          end_time = current_time
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1,
                    action_iterations: action_iterations }
        index_results!(results, options)
      end
    end
  end
end
