module Elasticsearch
  module API
    module Indices
      module Actions

        # Delete a single index alias.
        #
        # @example Delete an alias
        #
        #     client.indices.delete_alias index: 'foo', name: 'bar'
        #
        # See the {Indices::Actions#update_aliases} for performing operations with index aliases in bulk.
        #
        # @option arguments [List] :index A comma-separated list of index names (supports wildcards); use `_all` for all indices (*Required*)
        # @option arguments [List] :name A comma-separated list of aliases to delete (supports wildcards); use `_all` to delete all aliases for the specified indices. (*Required*)
        # @option arguments [Time] :timeout Explicit timestamp for the document
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html
        #
        def delete_alias(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing"  unless arguments[:name]
          method = HTTP_DELETE
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_alias', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete_alias, [
            :timeout,
            :master_timeout ].freeze)
      end
    end
  end
end
