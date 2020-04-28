# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions
          # Deactivates a currently active watch.
          #
          # @option arguments [String] :watch_id Watch ID
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/watcher-api-deactivate-watch.html
          #
          def deactivate_watch(arguments = {})
            raise ArgumentError, "Required argument 'watch_id' missing" unless arguments[:watch_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _watch_id = arguments.delete(:watch_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_watcher/watch/#{Elasticsearch::API::Utils.__listify(_watch_id)}/_deactivate"
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
