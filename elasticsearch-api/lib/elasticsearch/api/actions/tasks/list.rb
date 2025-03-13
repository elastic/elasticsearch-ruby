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
        # Get all tasks.
        # Get information about the tasks currently running on one or more nodes in the cluster.
        # WARNING: The task management API is new and should still be considered a beta feature.
        # The API may change in ways that are not backwards compatible.
        # **Identifying running tasks**
        # The +X-Opaque-Id header+, when provided on the HTTP request header, is going to be returned as a header in the response as well as in the headers field for in the task information.
        # This enables you to track certain calls or associate certain tasks with the client that started them.
        # For example:
        # +
        # curl -i -H "X-Opaque-Id: 123456" "http://localhost:9200/_tasks?group_by=parents"
        # +
        # The API returns the following result:
        # +
        # HTTP/1.1 200 OK
        # X-Opaque-Id: 123456
        # content-type: application/json; charset=UTF-8
        # content-length: 831
        # {
        #   "tasks" : {
        #     "u5lcZHqcQhu-rUoFaqDphA:45" : {
        #       "node" : "u5lcZHqcQhu-rUoFaqDphA",
        #       "id" : 45,
        #       "type" : "transport",
        #       "action" : "cluster:monitor/tasks/lists",
        #       "start_time_in_millis" : 1513823752749,
        #       "running_time_in_nanos" : 293139,
        #       "cancellable" : false,
        #       "headers" : {
        #         "X-Opaque-Id" : "123456"
        #       },
        #       "children" : [
        #         {
        #           "node" : "u5lcZHqcQhu-rUoFaqDphA",
        #           "id" : 46,
        #           "type" : "direct",
        #           "action" : "cluster:monitor/tasks/lists[n]",
        #           "start_time_in_millis" : 1513823752750,
        #           "running_time_in_nanos" : 92133,
        #           "cancellable" : false,
        #           "parent_task_id" : "u5lcZHqcQhu-rUoFaqDphA:45",
        #           "headers" : {
        #             "X-Opaque-Id" : "123456"
        #           }
        #         }
        #       ]
        #     }
        #   }
        #  }
        # +
        # In this example, +X-Opaque-Id: 123456+ is the ID as a part of the response header.
        # The +X-Opaque-Id+ in the task +headers+ is the ID for the task that was initiated by the REST request.
        # The +X-Opaque-Id+ in the children +headers+ is the child task of the task that was initiated by the REST request.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :actions A comma-separated list or wildcard expression of actions used to limit the request.
        #  For example, you can use +cluser:*+ to retrieve all cluster-related tasks.
        # @option arguments [Boolean] :detailed If +true+, the response includes detailed information about the running tasks.
        #  This information is useful to distinguish tasks from each other but is more costly to run.
        # @option arguments [String] :group_by A key that is used to group tasks in the response.
        #  The task lists can be grouped either by nodes or by parent tasks.
        # @option arguments [String, Array] :nodes A comma-separated list of node IDs or names that is used to limit the returned information.
        # @option arguments [String] :parent_task_id A parent task identifier that is used to limit returned information.
        #  To return all tasks, omit this parameter or use a value of +-1+.
        #  If the parent task is not found, the API does not return a 404 response code.
        # @option arguments [Time] :timeout The period to wait for each node to respond.
        #  If a node does not respond before its timeout expires, the response does not include its information.
        #  However, timed out nodes are included in the +node_failures+ property. Server default: 30s.
        # @option arguments [Boolean] :wait_for_completion If +true+, the request blocks until the operation is complete.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks
        #
        def list(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'tasks.list' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_tasks'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
