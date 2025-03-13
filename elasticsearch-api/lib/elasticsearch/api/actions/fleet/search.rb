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
    module Fleet
      module Actions
        # Run a Fleet search.
        # The purpose of the Fleet search API is to provide an API where the search will be run only
        # after the provided checkpoint has been processed and is visible for searches inside of Elasticsearch.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [Indexname, Indexalias] :index A single target to search. If the target is an index alias, it must resolve to a single index. (*Required*)
        # @option arguments [Boolean] :allow_no_indices [TODO]
        # @option arguments [String] :analyzer [TODO]
        # @option arguments [Boolean] :analyze_wildcard [TODO]
        # @option arguments [Integer] :batched_reduce_size [TODO]
        # @option arguments [Boolean] :ccs_minimize_roundtrips [TODO]
        # @option arguments [String] :default_operator [TODO]
        # @option arguments [String] :df [TODO]
        # @option arguments [String, Array<String>] :docvalue_fields [TODO]
        # @option arguments [String, Array<String>] :expand_wildcards [TODO]
        # @option arguments [Boolean] :explain [TODO]
        # @option arguments [Boolean] :ignore_throttled [TODO]
        # @option arguments [Boolean] :ignore_unavailable [TODO]
        # @option arguments [Boolean] :lenient [TODO]
        # @option arguments [Integer] :max_concurrent_shard_requests [TODO]
        # @option arguments [String] :preference [TODO]
        # @option arguments [Integer] :pre_filter_shard_size [TODO]
        # @option arguments [Boolean] :request_cache [TODO]
        # @option arguments [String] :routing [TODO]
        # @option arguments [Time] :scroll [TODO]
        # @option arguments [String] :search_type [TODO]
        # @option arguments [Array<String>] :stats [TODO]
        # @option arguments [String, Array<String>] :stored_fields [TODO]
        # @option arguments [String] :suggest_field Specifies which field to use for suggestions.
        # @option arguments [String] :suggest_mode [TODO]
        # @option arguments [Integer] :suggest_size [TODO]
        # @option arguments [String] :suggest_text The source text for which the suggestions should be returned.
        # @option arguments [Integer] :terminate_after [TODO]
        # @option arguments [Time] :timeout [TODO]
        # @option arguments [Boolean, Integer] :track_total_hits [TODO]
        # @option arguments [Boolean] :track_scores [TODO]
        # @option arguments [Boolean] :typed_keys [TODO]
        # @option arguments [Boolean] :rest_total_hits_as_int [TODO]
        # @option arguments [Boolean] :version [TODO]
        # @option arguments [Boolean, String, Array<String>] :_source [TODO]
        # @option arguments [String, Array<String>] :_source_excludes [TODO]
        # @option arguments [String, Array<String>] :_source_includes [TODO]
        # @option arguments [Boolean] :seq_no_primary_term [TODO]
        # @option arguments [String] :q [TODO]
        # @option arguments [Integer] :size [TODO]
        # @option arguments [Integer] :from [TODO]
        # @option arguments [String] :sort [TODO]
        # @option arguments [Array<Integer>] :wait_for_checkpoints A comma separated list of checkpoints. When configured, the search API will only be executed on a shard
        #  after the relevant checkpoint has become visible for search. Defaults to an empty list which will cause
        #  Elasticsearch to immediately execute the search. Server default: [].
        # @option arguments [Boolean] :allow_partial_search_results If true, returns partial results if there are shard request timeouts or {https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-replication.html#shard-failures shard failures}. If false, returns
        #  an error with no partial results. Defaults to the configured cluster setting +search.default_allow_partial_results+
        #  which is true by default.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-fleet-search
        #
        def search(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'fleet.search' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = "#{Utils.listify(_index)}/_fleet/_fleet_search"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
