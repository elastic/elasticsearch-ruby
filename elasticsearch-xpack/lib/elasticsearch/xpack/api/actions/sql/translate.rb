# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module SQL
        module Actions
          # Translates SQL into Elasticsearch queries
          #
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Specify the query in the `query` element. (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-translate.html
          #
          def translate(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_sql/translate"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
