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

        # Close an index (keep the data on disk, but deny operations with the index).
        #
        # A closed index can be opened again with the {Indices::Actions#close} API.
        #
        # @example Close index named _myindex_
        #
        #     client.indices.close index: 'myindex'
        #
        # @option arguments [List] :index A comma separated list of indices to perform the operation on
        #                                 (*Required*)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-open-close/
        #
        def close(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_close'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:close, [
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :timeout ].freeze)
      end
    end
  end
end
