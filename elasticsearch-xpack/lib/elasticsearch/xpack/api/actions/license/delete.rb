# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module License
        module Actions
          # Deletes licensing information for the cluster
          #

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/delete-license.html
          #
          def delete(arguments = {})
            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_license"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
