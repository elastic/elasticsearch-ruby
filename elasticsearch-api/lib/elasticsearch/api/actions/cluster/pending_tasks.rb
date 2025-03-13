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
    module Cluster
      module Actions
        # Get the pending cluster tasks.
        # Get information about cluster-level changes (such as create index, update mapping, allocate or fail shard) that have not yet taken effect.
        # NOTE: This API returns a list of any pending updates to the cluster state.
        # These are distinct from the tasks reported by the task management API which include periodic tasks and tasks initiated by the user, such as node stats, search queries, or create index requests.
        # However, if a user-initiated task such as a create index command causes a cluster state update, the activity of this task might be reported by both task api and pending cluster tasks API.
        #
        # @option arguments [Boolean] :local If +true+, the request retrieves information from the local node only.
        #  If +false+, information is retrieved from the master node.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-pending-tasks
        #
        def pending_tasks(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.pending_tasks' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_cluster/pending_tasks'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
