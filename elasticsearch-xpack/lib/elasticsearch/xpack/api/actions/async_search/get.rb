# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module AsyncSearch
        module Actions
          # Retrieves the results of a previously submitted async search request given its ID.
          #
          # @option arguments [String] :id The async search ID
          # @option arguments [Time] :wait_for_completion_timeout Specify the time that the request should block waiting for the final response
          # @option arguments [Time] :keep_alive Specify the time interval in which the results (partial or final) for this search will be available
          # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/async-search.html
          #
          def get(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_async_search/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get, [
            :wait_for_completion_timeout,
            :keep_alive,
            :typed_keys
          ].freeze)
      end
    end
    end
  end
end
