# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module License
        module Actions
          # Updates the license for the cluster.
          #
          # @option arguments [Boolean] :acknowledge whether the user has acknowledged acknowledge messages (default: false)

          # @option arguments [Hash] :body licenses to be installed
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/update-license.html
          #
          def post(arguments = {})
            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_PUT
            path   = "_license"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:post, [
            :acknowledge
          ].freeze)
      end
    end
    end
  end
end
