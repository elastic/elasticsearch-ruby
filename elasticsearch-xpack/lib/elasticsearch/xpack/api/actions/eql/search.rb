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

module Elasticsearch
  module XPack
    module API
      module Eql
        module Actions
          # Returns results matching a query expressed in Event Query Language (EQL)
          #
          # @option arguments [String] :index The name of the index to scope the operation
          # @option arguments [Time] :wait_for_completion_timeout Specify the time that the request should block waiting for the final response
          # @option arguments [Boolean] :keep_on_completion Control whether the response should be stored in the cluster if it completed within the provided [wait_for_completion] time (default: false)
          # @option arguments [Time] :keep_alive Update the time interval in which the results (partial or final) for this search will be available
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Eql request body. Use the `query` to limit the query scope. (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/eql-search-api.html
          #
          def search(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone
            arguments[:index] = UNDERSCORE_ALL if !arguments[:index] && arguments[:type]

            _index = arguments.delete(:index)

            method = if arguments[:body]
                       Elasticsearch::API::HTTP_POST
                     else
                       Elasticsearch::API::HTTP_GET
                     end

            path = "#{Elasticsearch::API::Utils.__listify(_index)}/_eql/search"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:search, [
            :wait_for_completion_timeout,
            :keep_on_completion,
            :keep_alive
          ].freeze)
        end
      end
    end
  end
end
