module Elasticsearch
  module API
    module Indices
      module Actions

        # Update the settings for one or multiple indices.
        #
        # @example Change the number of replicas for all indices
        #
        #     client.indices.put_settings body: { index: { number_of_replicas: 0 } }
        #
        #
        # @example Change the number of replicas for a specific index
        #
        #     client.indices.put_settings index: 'myindex', body: { index: { number_of_replicas: 0 } }
        #
        #
        # @example Disable "flush" for all indices
        #
        #     client.indices.put_settings body: { 'index.translog.disable_flush' => true }
        #
        # @example Allocate specific index on specific nodes
        #
        #     client.indices.put_settings index: 'my-big-index',
        #                                 body: { 'index.routing.allocation.require.tag' => 'bigbox' }
        #
        # @option arguments [Hash] :body The index settings to be updated (*Required*)
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                to perform the operation on all indices
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-update-settings/
        #
        def put_settings(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = 'PUT'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_settings'
          params = {}
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
