module Elasticsearch
  module API
    module Indices
      module Actions

        # Return the result of the analysis process (tokens)
        #
        # Allows to "test-drive" the Elasticsearch analysis process by performing the analysis on the
        # same text with different analyzers. An ad-hoc analysis chain can be built from specific
        # _tokenizer_ and _filters_.
        #
        # @example Analyze text "Quick Brown Jumping Fox" with the _snowball_ analyzer
        #
        #     client.indices.analyze text: 'The Quick Brown Jumping Fox', analyzer: 'snowball'
        #
        # @example Analyze text "Quick Brown Jumping Fox" with a custom tokenizer and filter chain
        #
        #     client.indices.analyze text: 'The Quick Brown Jumping Fox',
        #                            tokenizer: 'whitespace',
        #                            filters: ['lowercase','stop']
        #
        # @option arguments [String] :index The name of the index to scope the operation
        # @option arguments [Hash] :body The text on which the analysis should be performed
        # @option arguments [String] :analyzer The name of the analyzer to use
        # @option arguments [String] :field Use the analyzer configured for this field
        #                                   (instead of passing the analyzer name)
        # @option arguments [List] :filters A comma-separated list of filters to use for the analysis
        # @option arguments [String] :index The name of the index to scope the operation
        # @option arguments [Boolean] :prefer_local With `true`, specify that a local shard should be used if available,
        #                                           with `false`, use a random shard (default: true)
        # @option arguments [String] :text The text on which the analysis should be performed
        #                                  (when request body is not used)
        # @option arguments [String] :tokenizer The name of the tokenizer to use for the analysis
        # @option arguments [String] :format Format of the output (options: detailed, text)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-analyze/
        #
        def analyze(arguments={})
          valid_params = [
            :analyzer,
            :field,
            :filters,
            :index,
            :prefer_local,
            :text,
            :tokenizer,
            :format ]

          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_analyze'

          params = Utils.__validate_and_extract_params arguments, valid_params
          params[:filters] = Utils.__listify(params[:filters]) if params[:filters]

          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
