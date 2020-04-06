# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Actions
        # Retrieves information about the installed X-Pack features.
        #
        # @option arguments [List] :categories Comma-separated list of info categories. Can be any of: build, license, features

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/info-api.html
        #
        def info(arguments = {})
          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_GET
          path   = "_xpack"
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:info, [
          :categories
        ].freeze)
  end
      end
end
end
