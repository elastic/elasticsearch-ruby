# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Deletes an index.
        #
        # @option arguments [List] :index A comma-separated list of indices to delete; use `_all` or `*` string to delete all indices
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
        # @option arguments [Boolean] :allow_no_indices Ignore if a wildcard expression resolves to no concrete indices (default: false)
        # @option arguments [String] :expand_wildcards Whether wildcard expressions should get expanded to open or closed indices (default: open)
        #   (options: open,closed,none,all)

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-delete-index.html
        #
        def delete(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "#{Utils.__listify(_index)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete, [
          :timeout,
          :master_timeout,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards
        ].freeze)
end
      end
  end
end
