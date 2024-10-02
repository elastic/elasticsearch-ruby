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
        # Removes the archived repositories metering information present in the cluster.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [List] :node_id Comma-separated list of node IDs or names used to limit returned information.
        # @option arguments [Long] :max_archive_version Specifies the maximum archive_version to be cleared from the archive.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/clear-repositories-metering-archive-api.html
        #
        def clear_repositories_metering_archive(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.clear_repositories_metering_archive' }

          defined_params = %i[node_id max_archive_version].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'node_id' missing" unless arguments[:node_id]
          raise ArgumentError, "Required argument 'max_archive_version' missing" unless arguments[:max_archive_version]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _node_id = arguments.delete(:node_id)

          _max_archive_version = arguments.delete(:max_archive_version)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_nodes/#{Utils.__listify(_node_id)}/_repositories_metering/#{Utils.__listify(_max_archive_version)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
