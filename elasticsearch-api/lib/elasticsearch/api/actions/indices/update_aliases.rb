# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Updates index aliases.
        #
        # @option arguments [Time] :timeout Request timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The definition of `actions` to perform (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/indices-aliases.html
        #
        def update_aliases(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_POST
          path   = "_aliases"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:update_aliases, [
          :timeout,
          :master_timeout
        ].freeze)
end
      end
  end
end
