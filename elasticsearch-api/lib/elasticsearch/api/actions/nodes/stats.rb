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
        # Get node statistics.
        # Get statistics for nodes in a cluster.
        # By default, all stats are returned. You can limit the returned information by using metrics.
        #
        # @option arguments [String, Array] :node_id Comma-separated list of node IDs or names used to limit returned information.
        # @option arguments [String, Array<String>] :metric Limit the information returned to the specified metrics
        # @option arguments [String, Array<String>] :index_metric Limit the information returned for indices metric to the specific index metrics. It can be used only if indices (or all) metric is specified.
        # @option arguments [String, Array<String>] :completion_fields Comma-separated list or wildcard expressions of fields to include in fielddata and suggest statistics.
        # @option arguments [String, Array<String>] :fielddata_fields Comma-separated list or wildcard expressions of fields to include in fielddata statistics.
        # @option arguments [String, Array<String>] :fields Comma-separated list or wildcard expressions of fields to include in the statistics.
        # @option arguments [Boolean] :groups Comma-separated list of search groups to include in the search statistics.
        # @option arguments [Boolean] :include_segment_file_sizes If true, the call reports the aggregated disk usage of each one of the Lucene index files (only applies if segment stats are requested).
        # @option arguments [String] :level Indicates whether statistics are aggregated at the cluster, index, or shard level.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Array<String>] :types A comma-separated list of document types for the indexing index metric.
        # @option arguments [Boolean] :include_unloaded_segments If `true`, the response includes information from segments that are not loaded into memory.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-stats
        #
        def stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'nodes.stats' }

          defined_params = [:node_id, :metric, :index_metric].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _node_id = arguments.delete(:node_id)

          _metric = arguments.delete(:metric)

          _index_metric = arguments.delete(:index_metric)

          method = Elasticsearch::API::HTTP_GET
          path   = if _node_id && _metric && _index_metric
                     "_nodes/#{Utils.listify(_node_id)}/stats/#{Utils.listify(_metric)}/#{Utils.listify(_index_metric)}"
                   elsif _metric && _index_metric
                     "_nodes/stats/#{Utils.listify(_metric)}/#{Utils.listify(_index_metric)}"
                   elsif _node_id && _metric
                     "_nodes/#{Utils.listify(_node_id)}/stats/#{Utils.listify(_metric)}"
                   elsif _node_id
                     "_nodes/#{Utils.listify(_node_id)}/stats"
                   elsif _metric
                     "_nodes/stats/#{Utils.listify(_metric)}"
                   else
                     '_nodes/stats'
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
