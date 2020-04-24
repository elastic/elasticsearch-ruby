# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Deactivate a currently active watch
          #
          # @option arguments [String] :watch_id Watch ID (*Required*)
          # @option arguments [Duration] :master_timeout Specify timeout for watch write operation
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-deactivate-watch.html
          #
          def deactivate_watch(arguments={})
            raise ArgumentError, "Required argument 'watch_id' missing" unless arguments[:watch_id]
            valid_params = [ :master_timeout ]

            arguments = arguments.clone
            watch_id  = arguments.delete(:watch_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/watcher/watch/#{watch_id}/_deactivate"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
