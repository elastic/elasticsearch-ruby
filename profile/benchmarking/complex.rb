# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module Benchmarking

    # Class encapsulating all settings and functionality for running benchmarking
    #   tests making complex requests.
    #
    # @since 7.0.0
    class Complex
      include Measurable

      # Test sending a bulk request to index a large dataset.
      #
      # @example Test sending a bulk index request.
      #   task.create_documents(opts)
      #
      # @param [ Hash ] opts The test run options.
      #
      # @results [ Hash ] The results documents.
      #
      # @since 7.0.0
      def index_documents(opts = {})
        results = []
        slices = dataset_slices

        warmup_repetitions.times do
          slices.each do |slice|
            client.bulk(body: slice)
          end
        end

        duration = with_cleanup do
          Benchmark.realtime do
            results = measured_repetitions.times.collect do
              Benchmark.realtime do
                slices.each do |slice|
                  client.bulk(body: slice)
                end
              end
            end
          end
        end

        options = { duration: duration,
                    operation: __method__,
                    dataset: File.basename(DATASET_FILE),
                    dataset_size: ObjectSpace.memsize_of(dataset),
                    dataset_n_documents: dataset.length }
        index_results!(results, options)
      end

      # Test sending a request a search request.
      #
      # @example Test sending a search request.
      #   Benchmarking::Complex.search_documents(10)
      #
      # @param [ Integer ] repetitions The number of test repetitions.
      #
      # @since 7.0.0
      def search_documents(opts = {})
        results = []

        duration = with_cleanup do
          slices = dataset_slices
          sample_slice = slices.collect do |slice|
            client.bulk(body: slice)
            slice
          end[rand(slices.size)-1]

          sample_document = sample_slice[rand(sample_slice.size)-1][:index][:data]
          search_criteria = sample_document.find { |k,v| v.is_a?(String) }
          request = { body: { query: { match: { search_criteria[0] => search_criteria[1] } } } }

          warmup_repetitions.times do
            client.search(request)
          end

          Benchmark.realtime do
            results = measured_repetitions.times.collect do
              Benchmark.realtime do
                client.search(request)
              end
            end
          end
        end

        options = { duration: duration,
                    operation: __method__,
                    dataset: File.basename(DATASET_FILE),
                    dataset_size: ObjectSpace.memsize_of(dataset),
                    dataset_n_documents: dataset.length }
        index_results!(results, options)
      end

      # def mixed_bulk_small(repetitions)
      #
      # end
      #
      # def mixed_bulk_large(repetitions)
      #
      # end
    end
  end
end
