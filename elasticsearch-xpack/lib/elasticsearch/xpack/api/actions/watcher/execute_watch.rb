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

          # Force the execution of a stored watch
          #
          # @option arguments [String] :id Watch ID
          # @option arguments [Hash] :body Execution control
          # @option arguments [Boolean] :debug indicates whether the watch should execute in debug mode
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-execute-watch.html
          #
          def execute_watch(arguments={})
            valid_params = [ :debug ]
            method = Elasticsearch::API::HTTP_PUT

            path   = Elasticsearch::API::Utils.__pathify "_watcher/watch", arguments.delete(:id), "_execute"

            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
