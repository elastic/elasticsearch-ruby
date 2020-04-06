# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cluster
      module Actions
        # Updates the cluster settings.
        #
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout

        # @option arguments [Hash] :body The settings to be updated. Can be either `transient` or `persistent` (survives cluster restart). (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/cluster-update-settings.html
        #
        def put_settings(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_PUT
          path   = "_cluster/settings"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body] || {}
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:put_settings, [
          :flat_settings,
          :master_timeout,
          :timeout
        ].freeze)
end
      end
  end
end
