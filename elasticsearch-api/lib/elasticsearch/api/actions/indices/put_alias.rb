module Elasticsearch
  module API
    module Indices
      module Actions

        # Create or update a single index alias.
        #
        # @example Create an alias for current month
        #
        #     client.indices.put_alias index: 'logs-2013-06', name: 'current-month'
        #
        # @example Create an alias for multiple indices
        #
        #     client.indices.put_alias index: 'logs-2013-06', name: 'year-2013'
        #     client.indices.put_alias index: 'logs-2013-05', name: 'year-2013'
        #
        # See the {Indices::Actions#update_aliases} for performing operations with index aliases in bulk.
        #
        # @option arguments [String] :index The name of the index with an alias
        # @option arguments [String] :name The name of the alias to be created or updated
        # @option arguments [Hash] :body The settings for the alias, such as `routing` or `filter`
        # @option arguments [Time] :timeout Explicit timestamp for the document
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def put_alias(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing"  unless arguments[:name]
          method = 'PUT'
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_alias', Utils.__escape(arguments[:name])
          params = arguments.select do |k,v|
            [ :timeout ].include?(k)
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
