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
        # Get task information.
        # Get information about a task currently running in the cluster.
        # WARNING: The task management API is new and should still be considered a beta feature.
        # The API may change in ways that are not backwards compatible.
        # If the task identifier is not found, a 404 response code indicates that there are no resources that match the request.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :task_id The task identifier. (*Required*)
        # @option arguments [Time] :timeout The period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Boolean] :wait_for_completion If +true+, the request blocks until the task has completed.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks
        #
        def get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'tasks.get' }

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
          path   = "_tasks/#{Utils.listify(_task_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
