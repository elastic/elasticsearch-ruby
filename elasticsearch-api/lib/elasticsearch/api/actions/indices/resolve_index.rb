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
  module API
    module Indices
      module Actions
        # Returns information about any matching indices, aliases, and data streams
        #
        # @option arguments [List] :name A comma-separated list of names or wildcard expressions
        # @option arguments [String] :expand_wildcards Whether wildcard expressions should get expanded to open or closed indices (default: open) (options: open, closed, hidden, none, all)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/indices-resolve-index-api.html
        #
        def resolve_index(arguments = {})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_GET
          path   = "_resolve/index/#{Utils.__listify(_name)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:resolve_index, [
          :expand_wildcards
        ].freeze)
      end
    end
  end
end
