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
# Auto generated from build hash 589cd632d091bc0a512c46d5d81ac1f961b60127
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Fleet
      module Actions
        # The purpose of the fleet search api is to provide a search api where the search will only be executed
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :index The index name to search.
        # @option arguments [List] :wait_for_checkpoints Comma separated list of checkpoints, one per shard
        # @option arguments [Time] :wait_for_checkpoints_timeout Explicit wait_for_checkpoints timeout
        # @option arguments [Boolean] :allow_partial_search_results Indicate if an error should be returned if there is a partial search failure or timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The search definition using the Query DSL (*Required*)
        #
        # @see [TODO]
        #
        def search(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'fleet.search' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.__listify(_index)}/_fleet/_fleet_search"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
