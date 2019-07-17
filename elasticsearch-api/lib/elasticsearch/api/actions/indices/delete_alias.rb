# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
        # @option arguments [String] :index The name of the index with an alias (*Required*)
        # @option arguments [String] :name The name of the alias to be deleted (*Required*)
        # @option arguments [Time] :timeout Explicit timestamp for the document
        #
        # @see https://www.elastic.co/guide/reference/api/admin-indices-aliases/
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
        # @since 6.1.1
        ParamsRegistry.register(:delete_alias, [
            :timeout,
            :master_timeout ].freeze)
      end
    end
  end
end
