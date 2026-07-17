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
    module Actions
      # Throttle a reindex operation.
      # Change the maximum number of documents to index per second for a particular reindex operation.
      # For example, to unthrottle to unlimited documents per second:
      #
      # ```
      # POST _reindex/r1A2WoRbTwKZ516z6NEs5A:36619/_rethrottle?requests_per_second=-1
      # ```
      #
      # Rethrottling that speeds up the query takes effect immediately.
      # Rethrottling that slows down the query will take effect after completing the current batch of documents.
      # This behavior prevents scroll timeouts.
      # This API follows reindex tasks across node-shutdown relocations, so callers can keep using
      # the original task ID throughout the lifetime of the operation.
      # The relocated task ID is also accepted and is followed transparently.
      # In either case, returned task IDs and timings reflect the original task, not its relocated successor.
      # The rethrottle may not have been applied to any tasks if either `node_failures` or `task_failures` are non-empty, or if the response contains
      # no successfully rethrottled tasks — that is, no entries under `nodes` (returned with the default
      # `group_by=nodes` in stack) or under `tasks` (returned in serverless, or in stack with
      # `group_by=none` or `group_by=parents`).
      #
      # @option arguments [String] :task_id The task identifier, returned when creating a reindex task, or by listing tasks via
      #  `GET /_reindex` or `GET /_tasks`.
      #  In stack, can be either the original task ID or the task ID of the relocated task. (*Required*)
      # @option arguments [Float] :requests_per_second The maximum number of documents to index per second, across the entire reindex operation (including slices).
      #  It can be either `-1` to turn off throttling or any decimal number like `1.7` or `12` to throttle to that level. (*Required*)
      # @option arguments [String] :group_by The way to group the tasks in the response.
      #  We recommend setting this to `none`, which provides the cleanest response format. Server default: nodes.
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
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex
      #
      def reindex_rethrottle(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'reindex_rethrottle' }

        defined_params = [:task_id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'task_id' missing" unless arguments[:task_id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        _task_id = arguments.delete(:task_id)

        method = Elasticsearch::API::HTTP_POST
        path   = "_reindex/#{Utils.listify(_task_id)}/_rethrottle"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
