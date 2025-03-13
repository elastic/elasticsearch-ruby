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
    module AsyncSearch
      module Actions
        # Get async search results.
        # Retrieve the results of a previously submitted asynchronous search request.
        # If the Elasticsearch security features are enabled, access to the results of a specific async search is restricted to the user or API key that submitted it.
        #
        # @option arguments [String] :id A unique identifier for the async search. (*Required*)
        # @option arguments [Time] :keep_alive The length of time that the async search should be available in the cluster.
        #  When not specified, the +keep_alive+ set with the corresponding submit async request will be used.
        #  Otherwise, it is possible to override the value and extend the validity of the request.
        #  When this period expires, the search, if still running, is cancelled.
        #  If the search is completed, its saved results are deleted.
        # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
        # @option arguments [Time] :wait_for_completion_timeout Specifies to wait for the search to be completed up until the provided timeout.
        #  Final results will be returned if available before the timeout expires, otherwise the currently available results will be returned once the timeout expires.
        #  By default no timeout is set meaning that the currently available results will be returned without any additional wait.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-async-search-submit
        #
        def get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'async_search.get' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_async_search/#{Utils.listify(_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
