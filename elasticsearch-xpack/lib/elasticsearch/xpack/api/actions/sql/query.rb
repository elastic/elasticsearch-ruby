# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module SQL
        module Actions
          # Executes a SQL request
          #
          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml

          # @option arguments [Hash] :body Use the `query` element to start a query. Use the `cursor` element to continue a query. (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-rest-overview.html
          #
          def query(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_sql"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:query, [
            :format
          ].freeze)
      end
    end
    end
  end
end
