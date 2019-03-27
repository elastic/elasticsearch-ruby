module Elasticsearch
  module API
    module Indices
      module Actions

        # Create an index.
        #
        # Pass the index `settings` and `mappings` in the `:body` attribute.
        #
        # @example Create an index with specific settings, custom analyzers and mappings
        #
        #     client.indices.create index: 'test',
        #                           body: {
        #                             settings: {
        #                               index: {
        #                                 number_of_shards: 1,
        #                                 number_of_replicas: 0,
        #                                 'routing.allocation.include.name' => 'node-1'
        #                               },
        #                               analysis: {
        #                                 filter: {
        #                                   ngram: {
        #                                     type: 'nGram',
        #                                     min_gram: 3,
        #                                     max_gram: 25
        #                                   }
        #                                 },
        #                                 analyzer: {
        #                                   ngram: {
        #                                     tokenizer: 'whitespace',
        #                                     filter: ['lowercase', 'stop', 'ngram'],
        #                                     type: 'custom'
        #                                   },
        #                                   ngram_search: {
        #                                     tokenizer: 'whitespace',
        #                                     filter: ['lowercase', 'stop'],
        #                                     type: 'custom'
        #                                   }
        #                                 }
        #                               }
        #                             },
        #                             mappings: {
        #                               document: {
        #                                 properties: {
        #                                   title: {
        #                                     type: 'multi_field',
        #                                     fields: {
        #                                         title:  { type: 'string', analyzer: 'snowball' },
        #                                         exact:  { type: 'string', analyzer: 'keyword' },
        #                                         ngram:  { type: 'string',
        #                                                   index_analyzer: 'ngram',
        #                                                   search_analyzer: 'ngram_search'
        #                                         }
        #                                     }
        #                                   }
        #                                 }
        #                               }
        #                             }
        #                           }
        #
        # @option arguments [String] :index The name of the index (*Required*)
        # @option arguments [Hash] :body The configuration for the index (`settings` and `mappings`)
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for before the operation returns.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :update_all_types Whether to update the mapping for all fields with the same name across all types or not
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html
        #
        def create(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__escape(arguments[:index])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:create, [
            :wait_for_active_shards,
            :timeout,
            :master_timeout,
            :update_all_types,
            :include_type_name ].freeze)
      end
    end
  end
end
