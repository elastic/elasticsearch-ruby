module Elasticsearch
  module API
    module Indices
      module Actions

        # Create or update mapping.
        #
        # Pass the mapping definition(s) in the `:body` argument.
        #
        # @example Create or update a mapping for a specific document type
        #
        #     client.indices.put_mapping index: 'myindex', type: 'mytype', body: {
        #       mytype: {
        #         properties: {
        #           title: { type: 'string', analyzer: 'snowball' }
        #         }
        #       }
        #     }
        #
        # @option arguments [Hash] :body The mapping definition (*Required*)
        # @option arguments [List] :index A comma-separated list of index names; use `_all` to perform the operation
        #                                 on all indices (*Required*)
        # @option arguments [String] :type The name of the document type (*Required*)
        # @option arguments [Boolean] :ignore_conflicts Specify whether to ignore conflicts while updating the mapping
        #                                               (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-put-mapping/
        #
        def put_mapping(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
          raise ArgumentError, "Required argument 'body' missing"  unless arguments[:body]
          method = 'PUT'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), Utils.__escape(arguments[:type]), '_mapping'
          params = arguments.select do |k,v|
            [ :ignore_conflicts,
              :timeout ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
