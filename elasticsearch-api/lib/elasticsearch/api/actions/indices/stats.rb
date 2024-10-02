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
    module Indices
      module Actions
        # Provides statistics on operations happening in an index.
        #
        # @option arguments [List] :metric Limit the information returned the specific metrics. (options: _all, completion, docs, fielddata, query_cache, flush, get, indexing, merge, request_cache, refresh, search, segments, store, warmer, bulk)
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [List] :completion_fields A comma-separated list of fields for the `completion` index metric (supports wildcards)
        # @option arguments [List] :fielddata_fields A comma-separated list of fields for the `fielddata` index metric (supports wildcards)
        # @option arguments [List] :fields A comma-separated list of fields for `fielddata` and `completion` index metric (supports wildcards)
        # @option arguments [List] :groups A comma-separated list of search groups for `search` index metric
        # @option arguments [String] :level Return stats aggregated at cluster, index or shard level (options: cluster, indices, shards)
        # @option arguments [Boolean] :include_segment_file_sizes Whether to report the aggregated disk usage of each one of the Lucene index files (only applies if segment stats are requested)
        # @option arguments [Boolean] :include_unloaded_segments If set to true segment stats will include stats for segments that are not currently loaded into memory
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [Boolean] :forbid_closed_indices If set to false stats will also collected from closed indices if explicitly specified or if expand_wildcards expands to closed indices
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/indices-stats.html
        #
        def stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.stats' }

          defined_params = %i[metric index].each_with_object({}) do |variable, set_variables|
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
                     "#{Utils.__listify(_index)}/_stats/#{Utils.__listify(_metric)}"
                   elsif _metric
                     "_stats/#{Utils.__listify(_metric)}"
                   elsif _index
                     "#{Utils.__listify(_index)}/_stats"
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
