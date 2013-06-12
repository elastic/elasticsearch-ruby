module Elasticsearch
  module API
    module Utils

      # Create a "list" of values from arguments, ignoring nil values
      #
      # @example Create a list from array
      #     __listify(['A','B']) # => 'A,B'
      #
      # @example Create a list from arguments
      #     __listify('A','B') # => 'A,B'
      #
      # @api private
      def __listify(*list)
        Array(list).flatten.compact.join(',')
      end

      # Create a path (URL part) from arguments, ignoring nil values and empty strings
      #
      # @example Create a path from array
      #     __pathify(['foo', '', nil, 'bar']) # => 'foo/bar'
      #
      # @example Create a path from arguments
      #     __pathify('foo', '', nil, 'bar') # => 'foo/bar'
      #
      # @api private
      def __pathify(*segments)
        Array(segments).flatten.compact.reject { |s| s.to_s =~ /^\s*$/ }.join('/').squeeze('/')
      end

      extend self
    end
  end
end
