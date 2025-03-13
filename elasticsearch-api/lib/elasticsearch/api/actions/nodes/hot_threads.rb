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
    module Nodes
      module Actions
        # Get the hot threads for nodes.
        # Get a breakdown of the hot threads on each selected node in the cluster.
        # The output is plain text with a breakdown of the top hot threads for each node.
        #
        # @option arguments [String, Array] :node_id List of node IDs or names used to limit returned information.
        # @option arguments [Boolean] :ignore_idle_threads If true, known idle threads (e.g. waiting in a socket select, or to get
        #  a task from an empty queue) are filtered out. Server default: true.
        # @option arguments [Time] :interval The interval to do the second sampling of threads. Server default: 500ms.
        # @option arguments [Integer] :snapshots Number of samples of thread stacktrace. Server default: 10.
        # @option arguments [Integer] :threads Specifies the number of hot threads to provide information for. Server default: 3.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received
        #  before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [String] :type The type to sample. Server default: cpu.
        # @option arguments [String] :sort The sort order for 'cpu' type (default: total)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-hot-threads
        #
        def hot_threads(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.hot_threads' }

          defined_params = [:node_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _node_id = arguments.delete(:node_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _node_id
                     "_nodes/#{Utils.listify(_node_id)}/hot_threads"
                   else
                     '_nodes/hot_threads'
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
