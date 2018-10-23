module Elasticsearch
  module API
    module Indices
      module Actions

        # Get a list of all aliases, or aliases for a specific index.
        #
        # @example Get a list of all aliases
        #
        #     client.indices.get_aliases
        #
        # @option arguments [List] :index A comma-separated list of index names to filter aliases
        # @option arguments [List] :name A comma-separated list of alias names to filter
        # @option arguments [Time] :timeout Explicit timestamp for the document
        # @option arguments [Boolean] :local Return local information,
        #                                    do not retrieve the state from master node (default: false)
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-aliases.html
        #
        def get_aliases(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_aliases', Utils.__listify(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:get_aliases, [ :timeout, :local ].freeze)
      end
    end
  end
end
