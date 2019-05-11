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
  module API
    module Indices
      module Actions

        # Return the mapping definitions for all indices, or specific indices/types.
        #
        # @example Get all mappings in the cluster
        #
        #     client.indices.get_mapping
        #
        # @example Get mapping for a specific index
        #
        #     client.indices.get_mapping index: 'foo'
        #
        # @example Get mapping for a specific type in a specific index
        #
        #     client.indices.get_mapping index: 'foo', type: 'baz'
        #
        # @option arguments [List] :index A comma-separated list of index names
        # @option arguments [List] :type A comma-separated list of document types
        # @option arguments [Boolean] :include_type_name Whether to add the type name to the response (default: false)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-mapping.html
        #
        def get_mapping(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]),
                                   '_mapping',
                                   Utils.__listify(arguments[:type])
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:get_mapping, [
            :include_type_name,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :master_timeout,
            :local ].freeze)
      end
    end
  end
end
