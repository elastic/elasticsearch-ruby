# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Force the execution of a stored watch
          #
          # @option arguments [String] :id Watch ID
          # @option arguments [Hash] :body Execution control
          # @option arguments [Boolean] :debug indicates whether the watch should execute in debug mode
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-execute-watch.html
          #
          def execute_watch(arguments={})
            method = Elasticsearch::API::HTTP_PUT

            path   = Elasticsearch::API::Utils.__pathify "_watcher/watch", arguments.delete(:id), "_execute"

            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:execute_watch, [ :debug ].freeze)
        end
      end
    end
  end
end
