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

        warmup_repetitions.times { client.ping }

        results = measured_repetitions.times.collect do
          start = Time.now
          Benchmark.realtime do
            1000.times do
              client.ping
            end
          end
        end
        end_time = Time.now

        options = { duration: end_time - start,
                    operation: __method__ }
        results
        #index_results!(results, options)
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

        warmup_repetitions.times do
          client.indices.create(index: "benchmarking-#{Time.now.to_f}")
        end

        with_cleanup do
          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              10.times do
                client.indices.create(index: "benchmarking-#{Time.now.to_f}")
              end
            end
          end
          end_time = Time.now
          results
        end

        options = { duration: end_time - start,
                    operation: __method__ }
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

        warmup_repetitions.times do
          client.create(index: INDEX, body: document)
        end

        with_cleanup do
          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              10.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
          end_time = Time.now
          results
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1 }
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

        warmup_repetitions.times do
          client.create(index: INDEX, body: document)
        end

        with_cleanup do
          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.create(index: INDEX, body: document)
              end
            end
          end
          end_time = Time.now
          results
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'large_document',
                    dataset_size: ObjectSpace.memsize_of(large_document),
                    dataset_n_documents: 1 }
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

        with_cleanup do
          id = client.create(index: INDEX, body: small_document)['_id']
          warmup_repetitions.times do
            client.get(index: INDEX, id: id)
          end

          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.get(index: INDEX, id: id)
              end
            end
          end
          end_time = Time.now
          results
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1 }
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

        with_cleanup do
          id = client.create(index: INDEX, body: large_document)['_id']
          warmup_repetitions.times do
            client.get(index: INDEX, id: id)
          end

          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.get(index: INDEX, id: id)
              end
            end
          end
          end_time = Time.now
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'large_document',
                    dataset_size: ObjectSpace.memsize_of(large_document),
                    dataset_n_documents: 1 }
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

        with_cleanup do
          client.create(index: INDEX, body: small_document)
          search_criteria = { match: { 'user.lang': 'en' } }
          request = { body: { query: { match: search_criteria } } }
          if noop_plugin?
            Elasticsearch::API.const_set('UNDERSCORE_SEARCH', '_noop_search')
          else
            request.merge!(index: INDEX)
          end

          warmup_repetitions.times do
            client.search(request)
          end

          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.search(request)
              end
            end
          end
          end_time = Time.now
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1 }
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

        results = with_cleanup do
          client.create(index: INDEX, body: large_document)
          search_criteria = small_document.find { |k,v| k != 'id' && v.is_a?(String) }
          request = { body: { query: { match: { search_criteria[0] => search_criteria[1] } } } }
          if noop_plugin?
            Elasticsearch::API.const_set('UNDERSCORE_SEARCH', '_noop_search')
          else
            request.merge!(index: INDEX)
          end
          warmup_repetitions.times do
            client.search(request)
          end

          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do
                client.search(request)
              end
            end
          end
          end_time = Time.now
          results
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'large_document',
                    dataset_size: ObjectSpace.memsize_of(large_document),
                    dataset_n_documents: 1 }
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

        with_cleanup do
          document = small_document
          id = client.create(index: INDEX, body: document)['_id']
          field = document.find { |k,v| k != 'id' && v.is_a?(String) }.first

          warmup_repetitions.times do |i|
            client.update(index: INDEX,
                          id: id,
                          body: { doc: { field:  "#{document[field]}-#{i}" } })
          end

          start = Time.now
          results = measured_repetitions.times.collect do
            Benchmark.realtime do
              1_000.times do |i|
                client.update(index: INDEX,
                              id: id,
                              body: { doc: { field:  "#{document[field]}-#{i}" } })
              end
            end
          end
          end_time = Time.now
          results
        end

        options = { duration: end_time - start,
                    operation: __method__,
                    dataset: 'small_document',
                    dataset_size: ObjectSpace.memsize_of(small_document),
                    dataset_n_documents: 1 }
        index_results!(results, options)
      end
    end
  end
end
