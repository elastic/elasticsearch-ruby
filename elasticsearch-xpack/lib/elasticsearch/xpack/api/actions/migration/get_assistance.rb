# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Migration
        module Actions

          # Returns the information about indices that require some changes before the cluster can be upgraded to the next major version
          #
          # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
          # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
          # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
          # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/migration-api-assistance.html
          #
          def get_assistance(arguments={})
            method = Elasticsearch::API::HTTP_GET
            path   = "_migration/assistance"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_assistance, [ :allow_no_indices,
                                                     :expand_wildcards,
                                                     :ignore_unavailable ].freeze)
        end
      end
    end
  end
end
