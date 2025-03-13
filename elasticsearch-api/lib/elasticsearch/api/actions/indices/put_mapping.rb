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
    module Indices
      module Actions
        # Update field mappings.
        # Add new fields to an existing data stream or index.
        # You can also use this API to change the search settings of existing fields and add new properties to existing object fields.
        # For data streams, these changes are applied to all backing indices by default.
        # **Add multi-fields to an existing field**
        # Multi-fields let you index the same field in different ways.
        # You can use this API to update the fields mapping parameter and enable multi-fields for an existing field.
        # WARNING: If an index (or data stream) contains documents when you add a multi-field, those documents will not have values for the new multi-field.
        # You can populate the new multi-field with the update by query API.
        # **Change supported mapping parameters for an existing field**
        # The documentation for each mapping parameter indicates whether you can update it for an existing field using this API.
        # For example, you can use the update mapping API to update the +ignore_above+ parameter.
        # **Change the mapping of an existing field**
        # Except for supported mapping parameters, you can't change the mapping or field type of an existing field.
        # Changing an existing field could invalidate data that's already indexed.
        # If you need to change the mapping of a field in a data stream's backing indices, refer to documentation about modifying data streams.
        # If you need to change the mapping of a field in other indices, create a new index with the correct mapping and reindex your data into that index.
        # **Rename a field**
        # Renaming a field would invalidate data already indexed under the old field name.
        # Instead, add an alias field to create an alternate field name.
        #
        # @option arguments [String, Array] :index A comma-separated list of index names the mapping should be added to (supports wildcards); use +_all+ or omit to add the mapping on all indices. (*Required*)
        # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as +open,hidden+.
        #  Valid values are: +all+, +open+, +closed+, +hidden+, +none+. Server default: open.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Boolean] :write_index_only If +true+, the mappings are applied only to the current write index for the target.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-mapping
        #
        def put_mapping(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.put_mapping' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.listify(_index)}/_mapping"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
