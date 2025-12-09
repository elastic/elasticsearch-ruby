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
    module Eql
      module Actions
        # Get EQL search results.
        # Returns search results for an Event Query Language (EQL) query.
        # EQL assumes each document in a data stream or index corresponds to an event.
        #
        # @option arguments [String, Array] :index Comma-separated list of index names to scope the operation (*Required*)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices.
        #  (This includes `_all` string or when no indices have been specified) Server default: true.
        # @option arguments [Boolean] :allow_partial_search_results If true, returns partial results if there are shard failures. If false, returns an error with no partial results. Server default: true.
        # @option arguments [Boolean] :allow_partial_sequence_results If true, sequence queries will return partial results in case of shard failures. If false, they will return no results at all.
        #  This flag has effect only if allow_partial_search_results is true.
        # @option arguments [String, Array<String>] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. Server default: open.
        # @option arguments [Boolean] :ccs_minimize_roundtrips Indicates whether network round-trips should be minimized as part of cross-cluster search requests execution Server default: true.
        # @option arguments [Boolean] :ignore_unavailable If true, missing or closed indices are not included in the response. Server default: true.
        # @option arguments [Time] :keep_alive Period for which the search and its results are stored on the cluster. Server default: 5d.
        # @option arguments [Boolean] :keep_on_completion If true, the search and its results are stored on the cluster.
        # @option arguments [Time] :wait_for_completion_timeout Timeout duration to wait for the request to finish. Defaults to no timeout, meaning the request waits for complete search results.
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
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-eql-search
        #
        def search(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'eql.search' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.listify(_index)}/_eql/search"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
