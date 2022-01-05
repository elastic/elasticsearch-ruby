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
    module Actions
      # Returns information about the indices and shards that a search request would be executed against.
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/search-shards.html
      #
      def search_shards(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_GET
        path   = if _index
                   "#{Utils.__listify(_index)}/_search_shards"
                 else
                   "_search_shards"
                 end
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = nil
        perform_request(method, path, params, body, headers).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:search_shards, [
        :preference,
        :routing,
        :local,
        :ignore_unavailable,
        :allow_no_indices,
        :expand_wildcards
      ].freeze)
    end
  end
end
