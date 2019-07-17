# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module Transport

    # Class for wrapping a hash that could have sensitive data.
    # When printed, the sensitive values will be redacted.
    #
    # @since 6.1.1
    class Redacted < ::Hash

      def initialize(elements = nil)
        super()
        (elements || {}).each_pair{ |key, value| self[key] = value }
      end

      # The keys whose values will be redacted.
      #
      # @since 6.1.1
      SENSITIVE_KEYS = [ :password,
                         :pwd ].freeze

      # The replacement string used in place of the value for sensitive keys.
      #
      # @since 6.1.1
      STRING_REPLACEMENT = '<REDACTED>'.freeze

      # Get a string representation of the hash.
      #
      # @return [ String ] The string representation of the hash.
      #
      # @since 6.1.1
      def inspect
        redacted_string(:inspect)
      end

      # Get a string representation of the hash.
      #
      # @return [ String ] The string representation of the hash.
      #
      # @since 6.1.1
      def to_s
        redacted_string(:to_s)
      end

      private

      def redacted_string(method)
        '{' + reduce([]) do |list, (k, v)|
          list << "#{k.send(method)}=>#{redact(k, v, method)}"
        end.join(', ') + '}'
      end

      def redact(k, v, method)
        return STRING_REPLACEMENT if SENSITIVE_KEYS.include?(k.to_sym)
        v.send(method)
      end
    end
  end
end
