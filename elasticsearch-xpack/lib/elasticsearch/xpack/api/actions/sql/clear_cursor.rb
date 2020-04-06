# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module SQL
        module Actions
          # Clears the SQL cursor
          #

          # @option arguments [Hash] :body Specify the cursor value in the `cursor` element to clean the cursor. (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-pagination.html
          #
          def clear_cursor(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_sql/close"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
