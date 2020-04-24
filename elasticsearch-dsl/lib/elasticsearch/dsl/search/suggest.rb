# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search

      # Wraps the `suggest` part of a search definition
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-suggesters.html
      #
      class Suggest
        include BaseComponent

        def initialize(key, options={}, &block)
          @key     = key
          @options = options
          @block   = block
        end

        # Convert the definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash
          { @key => @options }
        end
      end
    end
  end
end
