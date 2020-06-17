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
      module Graph
        module Actions
          # Explore extracted and summarized information about the documents and terms in an index.
          #
          # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
          # @option arguments [String] :routing Specific routing value
          # @option arguments [Time] :timeout Explicit operation timeout
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Graph Query DSL
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/graph-explore-api.html
          #
          def explore(arguments = {})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _index = arguments.delete(:index)

            method = if arguments[:body]
                       Elasticsearch::API::HTTP_POST
                     else
                       Elasticsearch::API::HTTP_GET
                     end

            path = "#{Elasticsearch::API::Utils.__listify(_index)}/_graph/explore"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:explore, [
            :routing,
            :timeout
          ].freeze)
        end
      end
    end
  end
end
