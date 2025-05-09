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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Nodes
      module Actions
        # Clear the archived repositories metering.
        # Clear the archived repositories metering information in the cluster.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String, Array] :node_id Comma-separated list of node IDs or names used to limit returned information. (*Required*)
        # @option arguments [Integer] :max_archive_version Specifies the maximum `archive_version` to be cleared from the archive. (*Required*)
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-clear-repositories-metering-archive
        #
        def clear_repositories_metering_archive(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.clear_repositories_metering_archive' }

          defined_params = [:node_id, :max_archive_version].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'node_id' missing" unless arguments[:node_id]

          unless arguments[:max_archive_version]
            raise ArgumentError,
                  "Required argument 'max_archive_version' missing"
          end

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _node_id = arguments.delete(:node_id)

          _max_archive_version = arguments.delete(:max_archive_version)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_nodes/#{Utils.listify(_node_id)}/_repositories_metering/#{Utils.listify(_max_archive_version)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
