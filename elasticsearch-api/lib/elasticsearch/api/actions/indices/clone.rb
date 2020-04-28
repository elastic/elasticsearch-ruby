# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Clones an index
        #
        # @option arguments [String] :index The name of the source index to clone
        # @option arguments [String] :target The name of the target index to clone into
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the cloned index before the operation returns.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/indices-clone-index.html
        #
        def clone(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index = arguments.delete(:index)

          _target = arguments.delete(:target)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.__listify(_index)}/_clone/#{Utils.__listify(_target)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:clone, [
          :timeout,
          :master_timeout,
          :wait_for_active_shards
        ].freeze)
end
      end
  end
end
