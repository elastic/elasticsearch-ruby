# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

          # Get structured information about the vertices and connections in a dataset
          #
          # @option arguments [List] :index A comma-separated list of index names to search;
          #                                 use `_all` or empty string to perform the operation on all indices
          # @option arguments [List] :type A comma-separated list of document types to search;
          #                                leave empty to perform the operation on all types
          # @option arguments [Hash] :body The Graph Query DSL definition
          # @option arguments [String] :routing Specific routing value
          # @option arguments [Time] :timeout Explicit operation timeout
          #
          # @see https://www.elastic.co/guide/en/graph/current/explore.html
          #
          def explore(arguments={})
            valid_params = [
              :routing,
              :timeout ]

            arguments = arguments.clone
            index = arguments.delete(:index)
            type  = arguments.delete(:type)

            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify Elasticsearch::API::Utils.__listify(index), Elasticsearch::API::Utils.__listify(type), '_xpack/_graph/_explore'
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
