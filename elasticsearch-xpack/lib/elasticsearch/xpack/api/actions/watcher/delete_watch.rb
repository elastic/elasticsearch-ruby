# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :id Watch ID

          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-delete-watch.html
          #
          def delete_watch(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_watcher/watch/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = {}

            body = nil
            if Array(arguments[:ignore]).include?(404)
              Elasticsearch::API::Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
            else
              perform_request(method, path, params, body).body
            end
          end
      end
    end
    end
  end
end
