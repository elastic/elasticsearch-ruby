# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Performs the analysis process on a text and return the tokens breakdown of the text.
        #
        # @option arguments [String] :index The name of the index to scope the operation
        # @option arguments [String] :index The name of the index to scope the operation

        # @option arguments [Hash] :body Define analyzer/tokenizer parameters and the text on which the analysis should be performed
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-analyze.html
        #
        def analyze(arguments = {})
          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "#{Utils.__listify(_index)}/_analyze"
                   else
                     "_analyze"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:analyze, [
          :index
        ].freeze)
end
      end
  end
end
