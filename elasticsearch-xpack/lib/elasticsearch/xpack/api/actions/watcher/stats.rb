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
          # @option arguments [List] :metric Controls what additional stat metrics should be include in the response
          #   (options: _all,queued_watches,current_watches,pending_watches)

          # @option arguments [List] :metric Controls what additional stat metrics should be include in the response
          #   (options: _all,queued_watches,current_watches,pending_watches)

          # @option arguments [Boolean] :emit_stacktraces Emits stack traces of currently running watches

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-stats.html
          #
          def stats(arguments = {})
            arguments = arguments.clone

            _metric = arguments.delete(:metric)

            method = Elasticsearch::API::HTTP_GET
            path   = if _metric
                       "_watcher/stats/#{Elasticsearch::API::Utils.__listify(_metric)}"
                     else
                       "_watcher/stats"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:stats, [
            :metric,
            :emit_stacktraces
          ].freeze)
      end
    end
    end
  end
end
