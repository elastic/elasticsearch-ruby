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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Watcher
      module Actions
        # Acknowledges a watch, manually throttling the execution of the watch's actions.
        #
        # @option arguments [String] :watch_id Watch ID
        # @option arguments [List] :action_id A comma-separated list of the action ids to be acked
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/watcher-api-ack-watch.html
        #
        def ack_watch(arguments = {})
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
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
