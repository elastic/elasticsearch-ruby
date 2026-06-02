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
      # Get the status and progress of a specific reindex task.
      # This API follows reindex tasks across node-shutdown relocations, so callers can
      # keep using the original task ID throughout the lifetime of the operation.
      # Returned task IDs and timings reflect the original task, not its relocated successor.
      # Relocated task IDs are also supported. They are followed transparently and return the task ID and timings of the original task.
      # When the task ID cannot be resolved, the API returns the response below with a 404 status code.
      # This response is used whether the ID is unknown, refers to a non-reindex task, refers to a sliced child subtask, or refers to a task whose node left the cluster with no stored result (e.g. a non-graceful shutdown).
      #
      # ```
      # {
      #   "error": {
      #     "type": "resource_not_found_exception",
      #     "reason": "Reindex operation [r1A2WoRbTwKZ516z6NEs5A:36619] not found"
      #   },
      #   "status": 404
      # }
      # ```
      #
      # @option arguments [String] :task_id The ID of the reindex task to retrieve. (*Required*)
      # @option arguments [Boolean] :wait_for_completion If `true`, the request blocks until the reindex task completes, then returns the result.
      # @option arguments [Time] :timeout The period to wait for the reindex task to complete when `wait_for_completion` is `true`. Server default: 30s.
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
      # @see https://www.elastic.co/docs/api/doc/elasticsearch#TODO
      #
      def get_reindex(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'get_reindex' }

        defined_params = [:task_id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'task_id' missing" unless arguments[:task_id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        _task_id = arguments.delete(:task_id)

        method = Elasticsearch::API::HTTP_GET
        path   = "_reindex/#{Utils.listify(_task_id)}"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
