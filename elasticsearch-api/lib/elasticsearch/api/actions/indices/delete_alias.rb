module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_DELETE_ALIAS_PARAMS = [ :timeout ].freeze

        # Delete a single index alias.
        #
        # @example Delete an alias
        #
        #     client.indices.delete_alias index: 'foo', name: 'bar'
        #
        # See the {Indices::Actions#update_aliases} for performing operations with index aliases in bulk.
        #
        # @option arguments [String] :index The name of the index with an alias (*Required*)
        # @option arguments [String] :name The name of the alias to be deleted (*Required*)
        # @option arguments [Time] :timeout Explicit timestamp for the document
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def delete_alias(arguments={})
          delete_alias_request_for(arguments).body
        end

        def delete_alias_request_for(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing"  unless arguments[:name]
          method = HTTP_DELETE
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_alias', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, VALID_DELETE_ALIAS_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
