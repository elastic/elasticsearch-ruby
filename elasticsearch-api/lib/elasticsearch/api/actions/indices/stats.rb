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
    module Indices
      module Actions
        # Get index statistics.
        # For data streams, the API retrieves statistics for the stream's backing indices.
        # By default, the returned statistics are index-level with +primaries+ and +total+ aggregations.
        # +primaries+ are the values for only the primary shards.
        # +total+ are the accumulated values for both primary and replica shards.
        # To get shard-level statistics, set the +level+ parameter to +shards+.
        # NOTE: When moving to another node, the shard-level statistics for a shard are cleared.
        # Although the shard is no longer part of the node, that node retains any node-level statistics to which the shard contributed.
        #
        # @option arguments [String, Array<String>] :metric Limit the information returned the specific metrics.
        # @option arguments [String, Array] :index A comma-separated list of index names; use +_all+ or empty string to perform the operation on all indices
        # @option arguments [String, Array<String>] :completion_fields Comma-separated list or wildcard expressions of fields to include in fielddata and suggest statistics.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match. If the request can target data streams, this argument
        #  determines whether wildcard expressions match hidden data streams. Supports comma-separated values,
        #  such as +open,hidden+.
        # @option arguments [String, Array<String>] :fielddata_fields Comma-separated list or wildcard expressions of fields to include in fielddata statistics.
        # @option arguments [String, Array<String>] :fields Comma-separated list or wildcard expressions of fields to include in the statistics.
        # @option arguments [Boolean] :forbid_closed_indices If true, statistics are not collected from closed indices. Server default: true.
        # @option arguments [String] :groups Comma-separated list of search groups to include in the search statistics.
        # @option arguments [Boolean] :include_segment_file_sizes If true, the call reports the aggregated disk usage of each one of the Lucene index files (only applies if segment stats are requested).
        # @option arguments [Boolean] :include_unloaded_segments If true, the response includes information from segments that are not loaded into memory.
        # @option arguments [String] :level Indicates whether statistics are aggregated at the cluster, index, or shard level.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-stats
        #
        def stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.stats' }

          defined_params = [:metric, :index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _metric = arguments.delete(:metric)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index && _metric
                     "#{Utils.listify(_index)}/_stats/#{Utils.listify(_metric)}"
                   elsif _metric
                     "_stats/#{Utils.listify(_metric)}"
                   elsif _index
                     "#{Utils.listify(_index)}/_stats"
                   else
                     '_stats'
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
