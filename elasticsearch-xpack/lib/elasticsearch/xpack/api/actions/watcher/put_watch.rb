# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

          # Register a new watch in or update an existing one
          #
          # @option arguments [String] :id Watch ID (*Required*)
          # @option arguments [Hash] :body The watch (*Required*)
          # @option arguments [Duration] :master_timeout Specify timeout for watch write operation
          # @option arguments [Boolean] :active Specify whether the watch is in/active by default
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-put-watch.html
          #
          def put_watch(arguments={})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            valid_params = [
              :master_timeout,
              :active,
              :version,
              :if_seq_no,
              :if_primary_term ]

            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/watcher/watch/#{arguments[:id]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
