# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Deletes an alias.
        #
        # @option arguments [List] :index A comma-separated list of index names (supports wildcards); use `_all` for all indices
        # @option arguments [List] :name A comma-separated list of aliases to delete (supports wildcards); use `_all` to delete all aliases for the specified indices.
        # @option arguments [Time] :timeout Explicit timestamp for the document
        # @option arguments [Time] :master_timeout Specify timeout for connection to master

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-aliases.html
        #
        def delete_alias(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone

          _index = arguments.delete(:index)

          _name = arguments.delete(:name)

          method = HTTP_DELETE
          path   = if _index && _name
                     "#{Utils.__listify(_index)}/_aliases/#{Utils.__listify(_name)}"
  end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete_alias, [
          :timeout,
          :master_timeout
        ].freeze)
end
      end
  end
end
