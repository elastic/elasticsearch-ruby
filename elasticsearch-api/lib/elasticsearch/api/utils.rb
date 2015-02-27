module Elasticsearch
  module API

    # Generic utility methods
    #
    module Utils

      # URL-escape a string
      #
      # @example
      #     __escape('foo/bar') # => 'foo%2Fbar'
      #     __escape('bar^bam') # => 'bar%5Ebam'
      #
      # @api private
      def __escape(string)
        return string if string == '*'
        defined?(EscapeUtils) ? EscapeUtils.escape_url(string.to_s) : CGI.escape(string.to_s)
      end

      # Create a "list" of values from arguments, ignoring nil values and encoding special characters.
      #
      # @example Create a list from array
      #     __listify(['A','B']) # => 'A,B'
      #
      # @example Create a list from arguments
      #     __listify('A','B') # => 'A,B'
      #
      # @example Escape values
      #     __listify('foo','bar^bam') # => 'foo,bar%5Ebam'
      #
      # @api private
      def __listify(*list)
        Array(list).flatten.
          map { |e| e.respond_to?(:split) ? e.split(',') : e }.
          flatten.
          compact.
          map { |e| __escape(e) }.
          join(',')
      end

      # Create a path (URL part) from arguments, ignoring nil values and empty strings.
      #
      # @example Create a path from array
      #     __pathify(['foo', '', nil, 'bar']) # => 'foo/bar'
      #
      # @example Create a path from arguments
      #     __pathify('foo', '', nil, 'bar') # => 'foo/bar'
      #
      # # @example Encode special characters
      #     __pathify(['foo', 'bar^bam']) # => 'foo/bar%5Ebam'
      #
      # @api private
      def __pathify(*segments)
        Array(segments).flatten.
          compact.
          reject { |s| s.to_s =~ /^\s*$/ }.
          join('/').
          squeeze('/')
      end

      # Convert an array of payloads into Elasticsearch `header\ndata` format
      #
      #     Elasticsearch::API::Utils.__bulkify [
      #       { :index =>  { :_index => 'myindexA', :_type => 'mytype', :_id => '1', :data => { :title => 'Test' } } },
      #       { :update => { :_index => 'myindexB', :_type => 'mytype', :_id => '2', :data => { :doc => { :title => 'Update' } } } }
      #     ]
      #
      #     # => {"index":{"_index":"myindexA","_type":"mytype","_id":"1"}}
      #     # => {"title":"Test"}
      #     # => {"update":{"_index":"myindexB","_type":"mytype","_id":"2"}}
      #     # => {"doc":{"title":"Update"}}
      #
      def __bulkify(payload)
        case
        # Hashes with `:data`
        when payload.any? { |d| d.is_a?(Hash) && d.values.first.is_a?(Hash) && (d.values.first[:data] || d.values.first['data']) }
          payload = payload.
          inject([]) do |sum, item|
            operation, meta = item.to_a.first
            meta            = meta.clone
            data            = meta.delete(:data) || meta.delete('data')

            sum << { operation => meta }
            sum << data if data
            sum
          end.
          map { |item| MultiJson.dump(item) }
          payload << "" unless payload.empty?
          return payload.join("\n")

        # Array of strings
        when payload.all? { |d| d.is_a? String }
          payload << ''

        # Header/Data pairs
        else
          payload = payload.map { |item| MultiJson.dump(item) }
          payload << ''
        end

        payload = payload.join("\n")
      end

      # Validates the argument Hash against common and valid API parameters
      #
      # @param arguments    [Hash]          Hash of arguments to verify and extract, **with symbolized keys**
      # @param valid_params [Array<Symbol>] An array of symbols with valid keys
      #
      # @return [Hash]         Return whitelisted Hash
      # @raise [ArgumentError] If the arguments Hash contains invalid keys
      #
      # @example Extract parameters
      #   __validate_and_extract_params( { :foo => 'qux' }, [:foo, :bar] )
      #   # => { :foo => 'qux' }
      #
      # @example Raise an exception for invalid parameters
      #   __validate_and_extract_params( { :foo => 'qux', :bam => 'mux' }, [:foo, :bar] )
      #   # ArgumentError: "URL parameter 'bam' is not supported"
      #
      # @example Skip validating parameters
      #   __validate_and_extract_params( { :foo => 'q', :bam => 'm' }, [:foo, :bar], { skip_parameter_validation: true } )
      #   # => { :foo => "q", :bam => "m" }
      #
      # @example Skip validating parameters when the module setting is set
      #   Elasticsearch::API.settings[:skip_parameter_validation] = true
      #   __validate_and_extract_params( { :foo => 'q', :bam => 'm' }, [:foo, :bar] )
      #   # => { :foo => "q", :bam => "m" }
      #
      # @api private
      #
      def __validate_and_extract_params(arguments, params=[], options={})
        if options[:skip_parameter_validation] || Elasticsearch::API.settings[:skip_parameter_validation]
          arguments
        else
          __validate_params(arguments, params)
          __extract_params(arguments, params)
        end
      end

      def __validate_params(arguments, valid_params=[])
        arguments.each do |k,v|
          raise ArgumentError, "URL parameter '#{k}' is not supported" \
            unless COMMON_PARAMS.include?(k) || COMMON_QUERY_PARAMS.include?(k) || valid_params.include?(k)
        end
      end

      def __extract_params(arguments, params=[])
        result = arguments.select { |k,v| COMMON_QUERY_PARAMS.include?(k) || params.include?(k) }
        result = Hash[result] unless result.is_a?(Hash) # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        result = Hash[result.map { |k,v| v.is_a?(Array) ? [k, __listify(v)] : [k,v]  }] # Listify Arrays
        result
      end

      # Extracts the valid parts of the URL from the arguments
      #
      # @note Mutates the `arguments` argument, to prevent failures in `__validate_and_extract_params`.
      #
      # @param arguments   [Hash]          Hash of arguments to verify and extract, **with symbolized keys**
      # @param valid_parts [Array<Symbol>] An array of symbol with valid keys
      #
      # @return [Array<String>]            Valid parts of the URL as an array of strings
      #
      # @example Extract parts
      #   __extract_parts { :foo => true }, [:foo, :bar]
      #   # => [:foo]
      #
      #
      # @api private
      #
      def __extract_parts(arguments, valid_parts=[])
        # require 'pry'; binding.pry;
        # parts  = arguments.keys.select { |a| valid_parts.include?(a) }.map { |a| a.to_s }.sort

        parts = Hash[arguments.select { |k,v| valid_parts.include?(k) }]
        parts = parts.reduce([]) { |sum, item| k, v = item; v.is_a?(TrueClass) ? sum << k.to_s : sum << v  }

        arguments.delete_if { |k,v| valid_parts.include? k }
        return parts
      end

      # Calls given block, rescuing from any exceptions. Returns `false`
      # if exception contains NotFound/404 in its class name or message, else re-raises exception.
      #
      # @yield [block] A block of code to be executed with exception handling.
      #
      # @api private
      #
      def __rescue_from_not_found(&block)
        yield
      rescue Exception => e
        if e.class.to_s =~ /NotFound/ || e.message =~ /Not\s*Found|404/i
          false
        else
          raise e
        end
      end

      extend self
    end
  end
end
