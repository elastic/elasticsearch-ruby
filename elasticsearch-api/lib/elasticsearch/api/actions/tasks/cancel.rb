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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Tasks
      module Actions
        # Cancel a task.
        # WARNING: The task management API is new and should still be considered a beta feature.
        # The API may change in ways that are not backwards compatible.
        # A task may continue to run for some time after it has been cancelled because it may not be able to safely stop its current activity straight away.
        # It is also possible that Elasticsearch must complete its work on other tasks before it can process the cancellation.
        # The get task information API will continue to list these cancelled tasks until they complete.
        # The cancelled flag in the response indicates that the cancellation command has been processed and the task will stop as soon as possible.
        # To troubleshoot why a cancelled task does not complete promptly, use the get task information API with the +?detailed+ parameter to identify the other tasks the system is running.
        # You can also use the node hot threads API to obtain detailed information about the work the system is doing instead of completing the cancelled task.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String, Integer] :task_id The task identifier.
        # @option arguments [String] :actions A comma-separated list or wildcard expression of actions that is used to limit the request.
        # @option arguments [Array<String>] :nodes A comma-separated list of node IDs or names that is used to limit the request.
        # @option arguments [String] :parent_task_id A parent task ID that is used to limit the tasks.
        # @option arguments [Boolean] :wait_for_completion If true, the request blocks until all found tasks are complete.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks
        #
        def cancel(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'tasks.cancel' }

          defined_params = [:task_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _task_id = arguments.delete(:task_id)

          method = Elasticsearch::API::HTTP_POST
          path   = if _task_id
                     "_tasks/#{Utils.listify(_task_id)}/_cancel"
                   else
                     '_tasks/_cancel'
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
