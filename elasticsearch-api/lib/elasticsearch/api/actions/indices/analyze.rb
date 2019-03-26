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
        #     client.indices.analyze body: { text: 'The Quick Brown Jumping Fox',
        #                                    tokenizer: 'whitespace',
        #                                    filter: ['lowercase','stop'] }
        #
        # @note If your text for analysis is longer than 4096 bytes then you should use the :body argument, rather than :text, to avoid HTTP transport errors
        #
        # @example Analyze text "Quick <b>Brown</b> Jumping Fox" with custom tokenizer, token and character filters
        #
        # client.indices.analyze body: { text: 'The Quick <b>Brown</b> Jumping Fox',
        #                                tokenizer: 'standard',
        #                                char_filter: ['html_strip'] }
        #
        # @option arguments [String] :index The name of the index to scope the operation
        # @option arguments [Hash] :body Define analyzer/tokenizer parameters and the text on which the analysis should be performed
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-analyze/
        #
        def analyze(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_analyze'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:filters] = Utils.__listify(params[:filters]) if params[:filters]

          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:analyze, [
            :index ].freeze)
      end
    end
  end
end
