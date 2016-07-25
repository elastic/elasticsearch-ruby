# encoding: utf-8

module Elasticsearch
  module Extensions

    # This module allows copying documents from one index/cluster to another one
    #
    # When required together with the client, it will add the `reindex` method
    #
    # @see Reindex::Reindex.initialize
    # @see Reindex::Reindex#perform
    #
    # @see http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#reindex-instance_method
    #
    module Reindex

      # Initialize a new instance of the Reindex class (shortcut)
      #
      # @see Reindex::Reindex.initialize
      #
      def new(arguments={})
        Reindex.new(arguments)
      end; extend self

      module API
        # Copy documents from one index into another and refresh the target index
        #
        # @example
        #     client.reindex source: { index: 'test1' }, target: { index: 'test2' }, refresh: true
        #
        # The method allows all the options as {Reindex::Reindex.new}.
        #
        # This method will be mixed into the Elasticsearch client's API, if available.
        #
        def reindex(arguments={})
          arguments[:source] ||= {}
          arguments[:source][:client] = self
          Reindex.new(arguments).perform
        end
      end

      # Include the `reindex` method in the API and client, if available
      Elasticsearch::API::Actions.__send__ :include, API if defined?(Elasticsearch::API::Actions)
      Elasticsearch::Transport::Client.__send__ :include, API if defined?(Elasticsearch::Transport::Client) && defined?(Elasticsearch::API)

      # Copy documents from one index into another
      #
      # @example Copy documents to another index
      #
      #   client  = Elasticsearch::Client.new
      #   reindex = Elasticsearch::Extensions::Reindex.new \
      #               source: { index: 'test1', client: client },
      #               target: { index: 'test2' }
      #
      #   reindex.perform
      #
      # @example Copy documents to a different cluster
      #
      #     source_client  = Elasticsearch::Client.new url: 'http://localhost:9200'
      #     target_client  = Elasticsearch::Client.new url: 'http://localhost:9250'
      #
      #     reindex = Elasticsearch::Extensions::Reindex.new \
      #                 source: { index: 'test', client: source_client },
      #                 target: { index: 'test', client: target_client }
      #     reindex.perform
      #
      # @example Transform the documents during re-indexing
      #
      #     reindex = Elasticsearch::Extensions::Reindex.new \
      #                 source: { index: 'test1', client: client },
      #                 target: { index: 'test2' },
      #                 transform: lambda { |doc| doc['_source']['category'].upcase! }
      #
      #
      # The reindexing process works by "scrolling" an index and sending
      # batches via the "Bulk" API to the target index/cluster
      #
      # @option arguments [String] :source The source index/cluster definition (*Required*)
      # @option arguments [String] :target The target index/cluster definition (*Required*)
      # @option arguments [Proc] :transform A block which will be executed for each document
      # @option arguments [Integer] :batch_size The size of the batch for scroll operation (Default: 1000)
      # @option arguments [String] :scroll The timeout for the scroll operation (Default: 5min)
      # @option arguments [Boolean] :refresh Whether to refresh the target index after
      #                                      the operation is completed (Default: false)
      #
      # Be aware, that if you want to change the target index settings and/or mappings,
      # you have to do so in advance by using the "Indices Create" API.
      #
      # Note, that there is a native "Reindex" API in Elasticsearch 2.3.x and higer versions,
      # which will be more performant than the Ruby version.
      #
      # @see http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#reindex-instance_method
      #
      class Reindex
        attr_reader :arguments

        def initialize(arguments={})
          [
            [:source, :index],
            [:source, :client],
            [:target, :index]
          ].each do |required_option|
            value = required_option.reduce(arguments) { |sum, o| sum = sum[o] ? sum[o] : {}  }

            raise ArgumentError,
                  "Required argument '#{Hash[*required_option]}' missing" if \
                  value.respond_to?(:empty?) ? value.empty? : value.nil?
          end

          @arguments = {
            batch_size: 1000,
            scroll: '5m',
            refresh: false
          }.merge(arguments)

          arguments[:target][:client] ||= arguments[:source][:client]
        end

        # Performs the operation
        #
        # @return [Hash] A Hash with the information about the operation outcome
        #
        def perform
          output = { errors: 0 }

          response = arguments[:source][:client].search(
            index: arguments[:source][:index],
            scroll: arguments[:scroll],
            size: arguments[:batch_size]
          )

          documents = response['hits']['hits']

          unless documents.empty?
            bulk_response = __store_batch(documents)
            output[:errors] += bulk_response['items'].select { |k, v| k.values.first['error'] }.size
          end

          while response = arguments[:source][:client].scroll(scroll_id: response['_scroll_id'], scroll: arguments[:scroll]) do
            documents = response['hits']['hits']
            break if documents.empty?

            bulk_response = __store_batch(documents)
            output[:errors] += bulk_response['items'].select { |k, v| k.values.first['error'] }.size
          end

          arguments[:target][:client].indices.refresh index: arguments[:target][:index] if arguments[:refresh]

          output
        end

        def __store_batch(documents)
          body = documents.map do |doc|
            doc['_index'] = arguments[:target][:index]

            arguments[:transform].call(doc) if arguments[:transform]

            doc['data'] = doc['_source']
            doc.delete('_score')
            doc.delete('_source')

            { index: doc }
          end

          arguments[:target][:client].bulk body: body
        end
      end
    end
  end
end
