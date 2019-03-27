module Elasticsearch
  module API
    module Nodes
      module Actions

        # Returns information about nodes in the cluster (cluster settings, JVM version, etc).
        #
        # Use the `all` option to return all available settings, or limit the information returned
        # to a specific type (eg. `http`).
        #
        # Use the `node_id` option to limit information to specific node(s).
        #
        # @example Return information about JVM
        #
        #     client.nodes.info jvm: true
        #
        # @example Return information about HTTP and network
        #
        #     client.nodes.info http: true, network: true
        #
        # @example Pass a list of metrics
        #
        #     client.nodes.info metric: ['http', 'network']
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :metric A comma-separated list of metrics you wish returned. Leave empty to return all. (options: settings,os,process,jvm,thread_pool,transport,http,plugins,ingest)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html
        #
        def info(arguments={})
          arguments = arguments.clone
          metric    = arguments.delete(:metric)
          method = HTTP_GET
          if metric
            parts = metric
          else
            parts = Utils.__extract_parts arguments, ParamsRegistry.get(:info_parts)
          end

          path   = Utils.__pathify '_nodes', Utils.__listify(arguments[:node_id]), Utils.__listify(parts)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(:info_params)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:info_params, [ :flat_settings, :timeout ].freeze)

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:info, [
            :flat_settings,
            :timeout ].freeze)
      end
    end
  end
end
