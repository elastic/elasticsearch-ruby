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
        # Get feature usage information.
        #
        # @option arguments [String, Array] :node_id A comma-separated list of node IDs or names to limit the returned information; use +_local+ to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [String, Array<String>] :metric Limits the information returned to the specific metrics.
        #  A comma-separated list of the following options: +_all+, +rest_actions+.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-usage
        #
        def usage(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.usage' }

          defined_params = [:node_id, :metric].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _node_id = arguments.delete(:node_id)

          _metric = arguments.delete(:metric)

          method = Elasticsearch::API::HTTP_GET
          path   = if _node_id && _metric
                     "_nodes/#{Utils.listify(_node_id)}/usage/#{Utils.listify(_metric)}"
                   elsif _node_id
                     "_nodes/#{Utils.listify(_node_id)}/usage"
                   elsif _metric
                     "_nodes/usage/#{Utils.listify(_metric)}"
                   else
                     '_nodes/usage'
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
