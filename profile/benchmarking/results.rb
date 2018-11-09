module Elasticsearch
  module Benchmarking

    # Class encapsulating formatting and indexing the results from a benchmarking run.
    #
    # @since 7.0.0
    class Results

      # Create a Results object.
      #
      # @example Create a results object.
      #   Benchmarking::Results.new(task, [...])
      #
      # @param [ Elasticsearch::Benchmarking ] task The task that executed the benchmarking run.
      # @param [ Array<Fixnum> ] results An array of the results.
      # @param [ Hash ] opts The options.
      #
      # @since 7.0.0
      def initialize(task, results, opts = {})
        @task = task
        @results = results
        @options = opts
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
        client.index(index: index_name, body: results_doc)
        results_doc
      end

      private

      attr_reader :options

      DEFAULT_INDEX_NAME = 'benchmarking_results'.freeze

      DEFAULT_METRICS = ['median'].freeze

      CLIENT_NAME = 'elasticsearch-ruby-client'.freeze

      COMPLEXITIES = { Elasticsearch::Benchmarking::Simple => :simple }.freeze

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
          doc = { task: COMPLEXITIES[@task.class],
                  operation: options[:operation],
                  name: options['name'] || '',
                }
          doc[:client] = client_doc
          doc[:os] = os_doc
          doc[:platform] = platform
          results = metrics.inject({}) do |metrics, metric|
            metrics.merge(metric => send(metric))
          end
          doc.merge!(results: results)
        end
      end

      def median
        @results.sort![@results.size / 2 - 1]
      end

      def mean
        @results.inject{ |sum, el| sum + el }.to_f / @results.size
      end

      def max
        @results.max
      end

      def min
        @results.min
      end

      def metrics
        options['metrics'] || DEFAULT_METRICS
      end

      def os_doc
        {
          type: type,
          name: name,
          architecture: architecture
        }
      end

      def client_doc
        {
          name: CLIENT_NAME,
          version: Elasticsearch::VERSION
        }
      end

      def type
        (RbConfig::CONFIG && RbConfig::CONFIG['host_os']) ?
            RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase : 'unknown'
      end

      def name
        RbConfig::CONFIG['host_os']
      end

      def architecture
        RbConfig::CONFIG['target_cpu']
      end

      def platform
        [
          RUBY_VERSION,
          RUBY_PLATFORM,
          RbConfig::CONFIG['build']
        ].compact.join(', ')
      end
    end
  end
end
