module Elasticsearch
  module DSL

    # Generic utility methods
    #
    module Utils

      # Camelize an underscored string
      #
      # A lightweight version of ActiveSupport's `camelize`
      #
      # @example
      #     __camelize('query_string')
      #     # => 'QueryString'
      #
      # @api private
      #
      def __camelize(string)
        string.to_s.split('_').map(&:capitalize).join
      end

      extend self
    end
  end
end
