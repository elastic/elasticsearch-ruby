# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Return the current Watcher metrics
          #
          # @option arguments [String] :metric Additional metrics to be included in the response
          #                                   (options: _all, queued_watches, pending_watches)
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/watcher-api-stats.html
          #
          def stats(arguments={})
            valid_params = [ :metric, :emit_stacktraces ]
            method = Elasticsearch::API::HTTP_GET
            path   = "_watcher/stats"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
