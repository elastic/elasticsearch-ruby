module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_DELETE_PARAMS = [ :timeout ].freeze

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
        # @option arguments [List] :index A comma-separated list of indices to delete;
        #                                 use `_all` to delete all indices
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-index/
        #
        def delete(arguments={})
          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { delete_request_for(arguments).body }
          else
            delete_request_for(arguments).body
          end
        end

        def delete_request_for(arguments={})
          method = HTTP_DELETE
          path   = Utils.__pathify Utils.__listify(arguments[:index])

          params = Utils.__validate_and_extract_params arguments, VALID_DELETE_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
