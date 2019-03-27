module Elasticsearch
  module API
    module Indices
      module Actions

        # Delete an index, list of indices, or all indices in the cluster.
        #
        # @example Delete an index
        #
        #     client.indices.delete index: 'foo'
        #
        # @example Delete a list of indices
        #
        #     client.indices.delete index: ['foo', 'bar']
        #     client.indices.delete index: 'foo,bar'
        #
        #
        # @example Delete a list of indices matching wildcard expression
        #
        #     client.indices.delete index: 'foo*'
        #
        # @example Delete all indices
        #
        #     client.indices.delete index: '_all'
        #
        # @option arguments [List] :index A comma-separated list of indices to delete; use `_all` or `*` string to delete all indices (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
        # @option arguments [Boolean] :allow_no_indices Ignore if a wildcard expression resolves to no concrete indices (default: false)
        # @option arguments [String] :expand_wildcards Whether wildcard expressions should get expanded to open or closed indices (default: open) (options: open, closed, none, all)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html
        #
        def delete(arguments={})
          method = HTTP_DELETE
          path   = Utils.__pathify Utils.__listify(arguments[:index])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

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
            :expand_wildcards ].freeze)
      end
    end
  end
end
