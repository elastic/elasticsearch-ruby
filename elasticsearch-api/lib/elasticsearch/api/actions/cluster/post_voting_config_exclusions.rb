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
    module Cluster
      module Actions
        # Updates the cluster voting config exclusions by node ids or node names.
        #
        # @option arguments [String] :node_ids A comma-separated list of the persistent ids of the nodes to exclude from the voting configuration. If specified, you may not also specify ?node_names.
        # @option arguments [String] :node_names A comma-separated list of the names of the nodes to exclude from the voting configuration. If specified, you may not also specify ?node_ids.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Timeout for submitting request to master
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/voting-config-exclusions.html
        #
        def post_voting_config_exclusions(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.post_voting_config_exclusions' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_cluster/voting_config_exclusions'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
