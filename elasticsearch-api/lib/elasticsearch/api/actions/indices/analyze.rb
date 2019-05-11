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
        # @option arguments [String] :body The text on which the analysis should be performed
        # @option arguments [String] :analyzer The name of the analyzer to use
        # @option arguments [String] :field Use the analyzer configured for this field
        #                                   (instead of passing the analyzer name)
        # @option arguments [List] :filters A comma-separated list of token filters to use for the analysis.
        #                                   (Also available as the `:token_filters` option)
        # @option arguments [List] :char_filters A comma-separated list of char filters to use for the analysis
        # @option arguments [Boolean] :explain Whether to output further details (default: false)
        # @option arguments [List] :attributes A comma-separated list of token attributes to output (use with `:explain`)
        # @option arguments [String] :index The name of the index to scope the operation
        # @option arguments [Boolean] :prefer_local With `true`, specify that a local shard should be used if available,
        #                                           with `false`, use a random shard (default: true)
        # @option arguments [String] :text The text on which the analysis should be performed
        #                                  (when request body is not used)
        # @option arguments [String] :tokenizer The name of the tokenizer to use for the analysis
        #
        # @see https://www.elastic.co/guide/reference/api/admin-indices-analyze/
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
        #
        # @since 6.1.1
        ParamsRegistry.register(:analyze, [
            :index ].freeze)
      end
    end
  end
end
