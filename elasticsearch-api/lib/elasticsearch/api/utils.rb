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
        payload = payload.
        inject([]) do |sum, item|
          operation, meta = item.to_a.first
          data            = meta.delete(:data)

          sum << { operation => meta }
          sum << data if data
          sum
        end.
        map { |item| MultiJson.dump(item) }
        payload << "" unless payload.empty?
        payload = payload.join("\n")
      end

      extend self
    end
  end
end
