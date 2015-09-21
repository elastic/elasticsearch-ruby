module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_CREATE_PARAMS = [ :timeout ].freeze

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
        # @option arguments [Hash] :body Optional configuration for the index (`settings` and `mappings`)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-create-index/
        #
        def create(arguments={})
          create_request_for(arguments).body
        end

        def create_request_for(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__escape(arguments[:index])

          params = Utils.__validate_and_extract_params arguments, VALID_CREATE_PARAMS
          body   = arguments[:body]

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
