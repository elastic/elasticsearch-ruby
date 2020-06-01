# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions
          # Creates a new watch, or updates an existing one.
          #
          # @option arguments [String] :id Watch ID
          # @option arguments [Boolean] :active Specify whether the watch is in/active by default
          # @option arguments [Number] :version Explicit version number for concurrency control
          # @option arguments [Number] :if_seq_no only update the watch if the last operation that has changed the watch has the specified sequence number
          # @option arguments [Number] :if_primary_term only update the watch if the last operation that has changed the watch has the specified primary term
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The watch
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/watcher-api-put-watch.html
          #
          def put_watch(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_watcher/watch/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
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
