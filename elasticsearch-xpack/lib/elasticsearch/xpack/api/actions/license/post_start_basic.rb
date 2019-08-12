# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module License
        module Actions

          # TODO: Description
          #
          # @option arguments [Boolean] :acknowledge whether the user has acknowledged acknowledge messages (default: false)
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/license-management.html
          #
          def post_start_basic(arguments={})
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/license/start_basic"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:post_start_basic, [ :acknowledge ].freeze)
        end
      end
    end
  end
end
