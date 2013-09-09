module Elasticsearch
  module API
    module Actions

      # Delete a single document.
      #
      # @example Delete a document
      #
      #     client.delete index: 'myindex', type: 'mytype', id: '1'
      #
      # @example Delete a document with specific routing
      #
      #     client.delete index: 'myindex', type: 'mytype', id: '1', routing: 'abc123'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [Number,List] :ignore The list of HTTP errors to ignore; only `404` supported at the moment
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [String] :consistency Specific write consistency setting for the operation
      #                                         (options: one, quorum, all)
      # @option arguments [String] :parent ID of parent document
      # @option arguments [Boolean] :refresh Refresh the index after performing the operation
      # @option arguments [String] :replication Specific replication type (options: sync, async)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external)
      #
      # @see http://elasticsearch.org/guide/reference/api/delete/
      #
      def delete(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        method = 'DELETE'
        path   = Utils.__pathify( arguments[:index], arguments[:type], arguments[:id] )
        params = arguments.select do |k,v|
          [ :consistency,
            :parent,
            :refresh,
            :replication,
            :routing,
            :timeout,
            :version,
            :version_type ].include?(k)
        end
        # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        params = Hash[params] unless params.is_a?(Hash)
        body   = nil

        perform_request(method, path, params, body).body

      rescue Exception => e
        # NOTE: Use exception name, not full class in Elasticsearch::Client to allow client plugability
        if arguments[:ignore] == 404 && e.class.to_s =~ /NotFound/; false
        else raise(e)
        end
      end
    end
  end
end
