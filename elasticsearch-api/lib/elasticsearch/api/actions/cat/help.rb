# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cat
      module Actions
        # Returns help for the Cat APIs.
        #
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/cat.html
        #
        def help(arguments = {})
          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_GET
          path   = "_cat"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:help, [
          :help,
          :s
        ].freeze)
end
      end
  end
end
