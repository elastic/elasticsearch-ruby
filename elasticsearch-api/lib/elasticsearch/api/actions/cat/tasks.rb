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
    module Cat
      module Actions
        # Returns information about the tasks currently executing on one or more nodes in the cluster.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [List] :nodes A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :actions A comma-separated list of actions that should be returned. Leave empty to return all.
        # @option arguments [Boolean] :detailed Return detailed task information (default: false)
        # @option arguments [String] :parent_task_id Return tasks with specified parent task id (node_id:task_number). Set to -1 to return all.
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/tasks.html
        #
        def tasks(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.tasks' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_cat/tasks'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
