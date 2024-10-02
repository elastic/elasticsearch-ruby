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
    module Nodes
      module Actions
        # Returns information about nodes in the cluster.
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :metric A comma-separated list of metrics you wish returned. Use `_all` to retrieve all metrics and `_none` to retrieve the node identity without any additional metrics. (options: settings, os, process, jvm, thread_pool, transport, http, plugins, ingest, indices, aggregations, _all, _none)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/cluster-nodes-info.html
        #
        def info(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.info' }

          defined_params = %i[node_id metric].each_with_object({}) do |variable, set_variables|
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
                     "_nodes/#{Utils.__listify(_node_id)}/#{Utils.__listify(_metric)}"
                   elsif _node_id
                     "_nodes/#{Utils.__listify(_node_id)}"
                   elsif _metric
                     "_nodes/#{Utils.__listify(_metric)}"
                   else
                     '_nodes'
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
