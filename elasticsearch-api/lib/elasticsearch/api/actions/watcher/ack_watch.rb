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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Watcher
      module Actions
        # Acknowledge a watch.
        # Acknowledging a watch enables you to manually throttle the execution of the watch's actions.
        # The acknowledgement state of an action is stored in the `status.actions.<id>.ack.state` structure.
        # IMPORTANT: If the specified watch is currently being executed, this API will return an error
        # The reason for this behavior is to prevent overwriting the watch status from a watch execution.
        # Acknowledging an action throttles further executions of that action until its `ack.state` is reset to `awaits_successful_execution`.
        # This happens when the condition of the watch is not met (the condition evaluates to false).
        # To demonstrate how throttling works in practice and how it can be configured for individual actions within a watch, refer to External documentation.
        #
        # @option arguments [String] :watch_id The watch identifier. (*Required*)
        # @option arguments [String, Array<String>] :action_id A comma-separated list of the action identifiers to acknowledge.
        #  If you omit this parameter, all of the actions of the watch are acknowledged.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-watcher-ack-watch
        #
        def ack_watch(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'watcher.ack_watch' }

          defined_params = [:watch_id, :action_id].each_with_object({}) do |variable, set_variables|
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
                     "_watcher/watch/#{Utils.listify(_watch_id)}/_ack/#{Utils.listify(_action_id)}"
                   else
                     "_watcher/watch/#{Utils.listify(_watch_id)}/_ack"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
