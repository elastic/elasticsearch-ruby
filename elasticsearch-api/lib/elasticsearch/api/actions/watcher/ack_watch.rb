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
#
# Auto generated from build hash 589cd632d091bc0a512c46d5d81ac1f961b60127
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Watcher
      module Actions
        # Acknowledge a watch
        #
        # @option arguments [String] :watch_id Watch ID
        # @option arguments [List] :action_id A comma-separated list of the action ids to be acked
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v8/operation/operation-watcher-ack-watch
        #
        def ack_watch(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'watcher.ack_watch' }

          defined_params = %i[watch_id action_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'watch_id' missing" unless arguments[:watch_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _watch_id = arguments.delete(:watch_id)

          _action_id = arguments.delete(:action_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _watch_id && _action_id
                     "_watcher/watch/#{Utils.__listify(_watch_id)}/_ack/#{Utils.__listify(_action_id)}"
                   else
                     "_watcher/watch/#{Utils.__listify(_watch_id)}/_ack"
                   end
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
