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
          # @option arguments [Boolean] :active Specify whether the watch is in/active by default
          # @option arguments [Number] :version Explicit version number for concurrency control
          # @option arguments [Number] :if_seq_no only update the watch if the last operation that has changed the watch has the specified sequence number
          # @option arguments [Number] :if_primary_term only update the watch if the last operation that has changed the watch has the specified primary term

          # @option arguments [Hash] :body The watch
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-put-watch.html
          #
          def put_watch(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_watcher/watch/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:put_watch, [
            :active,
            :version,
            :if_seq_no,
            :if_primary_term
          ].freeze)
      end
    end
    end
  end
end
