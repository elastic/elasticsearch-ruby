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
    module Eql
      module Actions
        # Get EQL search results.
        # Returns search results for an Event Query Language (EQL) query.
        # EQL assumes each document in a data stream or index corresponds to an event.
        #
        # @option arguments [String, Array] :index The name of the index to scope the operation (*Required*)
        # @option arguments [Boolean] :allow_no_indices [TODO] Server default: true.
        # @option arguments [Boolean] :allow_partial_search_results If true, returns partial results if there are shard failures. If false, returns an error with no partial results. Server default: true.
        # @option arguments [Boolean] :allow_partial_sequence_results If true, sequence queries will return partial results in case of shard failures. If false, they will return no results at all.
        #  This flag has effect only if allow_partial_search_results is true.
        # @option arguments [String, Array<String>] :expand_wildcards [TODO] Server default: open.
        # @option arguments [Boolean] :ignore_unavailable If true, missing or closed indices are not included in the response. Server default: true.
        # @option arguments [Time] :keep_alive Period for which the search and its results are stored on the cluster. Server default: 5d.
        # @option arguments [Boolean] :keep_on_completion If true, the search and its results are stored on the cluster.
        # @option arguments [Time] :wait_for_completion_timeout Timeout duration to wait for the request to finish. Defaults to no timeout, meaning the request waits for complete search results.
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
