# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Actions
        # Retrieves usage information about the installed X-Pack features.
        #
        # @option arguments [Time] :master_timeout Specify timeout for watch write operation
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/usage-api.html
        #
        def usage(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_GET
          path   = "_xpack/usage"
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:usage, [
          :master_timeout
        ].freeze)
  end
      end
end
end
