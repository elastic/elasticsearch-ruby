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

        # Clear caches and other auxiliary data structures.
        #
        # Can be performed against a specific index, or against all indices.
        #
        # By default, all caches and data structures will be cleared.
        # Pass a specific cache or structure name to clear just a single one.
        #
        # @example Clear all caches and data structures
        #
        #     client.indices.clear_cache
        #
        # @example Clear the field data structure only
        #
        #     client.indices.clear_cache field_data: true
        #
        # @example Clear only specific field in the field data structure
        #
        #     client.indices.clear_cache field_data: true, fields: 'created_at', filter_cache: false, id_cache: false
        #
        # @option arguments [List] :index A comma-separated list of index name to limit the operation
        # @option arguments [Boolean] :field_data Clear field data
        # @option arguments [Boolean] :fielddata Clear field data
        # @option arguments [List] :fields A comma-separated list of fields to clear when using the `field_data` parameter (default: all)
        # @option arguments [Boolean] :query Clear query caches
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [List] :index A comma-separated list of index name to limit the operation
        # @option arguments [Boolean] :recycler Clear the recycler cache
        # @option arguments [Boolean] :request_cache Clear request cache
        # @option arguments [Boolean] :request Clear request cache
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-clearcache.html
        #
        def clear_cache(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_cache/clear'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:clear_cache, [
            :fielddata,
            :fields,
            :query,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :index,
            :request ].freeze)
      end
    end
  end
end
