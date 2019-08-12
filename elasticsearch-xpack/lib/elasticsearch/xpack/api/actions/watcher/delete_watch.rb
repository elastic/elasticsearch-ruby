# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Remove a watch
          #
          # @option arguments [String] :id Watch ID (*Required*)
          # @option arguments [Duration] :master_timeout Specify timeout for watch write operation
          # @option arguments [Boolean] :force Specify if this request should be forced and ignore locks
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/appendix-api-delete-watch.html
          #
          def delete_watch(arguments={})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/watcher/watch/#{arguments[:id]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            if Array(arguments[:ignore]).include?(404)
              Elasticsearch::API::Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
            else
              perform_request(method, path, params, body).body
            end
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:delete_watch, [ :master_timeout,
                                                   :force ].freeze)
        end
      end
    end
  end
end
