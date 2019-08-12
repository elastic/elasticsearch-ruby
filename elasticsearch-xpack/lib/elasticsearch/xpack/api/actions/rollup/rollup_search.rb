# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :index The index or index-pattern (containing rollup or regular data) that should be searched (*Required*)
          # @option arguments [String] :type The doc type inside the index
          # @option arguments [Hash] :body The search request body (*Required*)
          #
          # @see
          #
          def rollup_search(arguments={})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_GET
            path   = "#{arguments[:index]}/_rollup_search"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:rollup_search, [ :typed_keys,
                                                    :rest_total_hits_as_int ].freeze)
        end
      end
    end
  end
end
