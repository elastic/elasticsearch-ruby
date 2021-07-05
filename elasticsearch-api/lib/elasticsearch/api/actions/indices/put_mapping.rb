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
        # Updates the index mappings.
        #
        # @option arguments [List] :index A comma-separated list of index names the mapping should be added to (supports wildcards); use `_all` or omit to add the mapping on all indices.
        # @option arguments [String] :type The name of the document type *Deprecated*
        # @option arguments [Boolean] :include_type_name Whether a type should be expected in the body of the mappings.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
        # @option arguments [Boolean] :write_index_only When true, applies mappings only to the write index of an alias or data stream
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The mapping definition (*Required*)
        #
        # *Deprecation notice*:
        # Specifying types in urls has been deprecated
        # Deprecated since version 7.0.0
        #
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.14/indices-put-mapping.html
        #
        def put_mapping(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index = arguments.delete(:index)

          _type = arguments.delete(:type)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _index && _type
                     "#{Utils.__listify(_index)}/#{Utils.__listify(_type)}/_mappings"
                   elsif _index
                     "#{Utils.__listify(_index)}/_mappings"
                   elsif _type
                     "_mappings/#{Utils.__listify(_type)}"
                   end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:put_mapping, [
          :include_type_name,
          :timeout,
          :master_timeout,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :write_index_only
        ].freeze)
      end
    end
  end
end
