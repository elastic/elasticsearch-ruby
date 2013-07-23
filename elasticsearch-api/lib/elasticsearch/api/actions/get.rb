module Elasticsearch
  module API
    module Actions

      # Return a specified document.
      #
      # The response contains full document, as stored in Elasticsearch, incl. `_source`, `_version`, etc.
      #
      # @example Get a document
      #
      #     client.get index: 'myindex', type: 'mytype', id: '1'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document; use `_all` to fetch the first document
      #                                  matching the ID across all types) (*Required*)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      #
      # @see http://elasticsearch.org/guide/reference/api/get/
      #
      def get(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        method = 'GET'
        path   = "#{arguments[:index]}/#{arguments[:type]}/#{arguments[:id]}"
        params = arguments.select do |k,v|
          [ :fields,
            :parent,
            :preference,
            :realtime,
            :refresh,
            :routing ].include?(k)
        end
        # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        params = Hash[params] unless params.is_a?(Hash)
        body   = nil

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        perform_request(method, path, params, body).body
      end
    end
  end
end
