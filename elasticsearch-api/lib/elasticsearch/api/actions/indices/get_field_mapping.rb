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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Indices
      module Actions
        # Get mapping definitions.
        # Retrieves mapping definitions for one or more fields.
        # For data streams, the API retrieves field mappings for the stream’s backing indices.
        # This API is useful if you don't need a complete mapping or if an index mapping contains a large number of fields.
        #
        # @option arguments [String, Array<String>] :fields Comma-separated list or wildcard expression of fields used to limit returned information.
        #  Supports wildcards (`*`). (*Required*)
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit the request.
        #  Supports wildcards (`*`).
        #  To target all data streams and indices, omit this parameter or use `*` or `_all`.
        # @option arguments [Boolean] :allow_no_indices A setting that does two separate checks on the index expression.
        #  If `false`, the request returns an error (1) if any wildcard expression
        #  (including `_all` and `*`) resolves to zero matching indices or (2) if the
        #  complete set of resolved indices, aliases or data streams is empty after all
        #  expressions are evaluated. If `true`, index expressions that resolve to no
        #  indices are allowed and the request returns an empty result. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as `open,hidden`. Server default: open.
        # @option arguments [Boolean] :ignore_unavailable If `false`, the request returns an error if it targets a concrete (non-wildcarded)
        #  index, alias, or data stream that is missing, closed, or otherwise unavailable.
        #  If `true`, unavailable concrete targets are silently ignored.
        # @option arguments [Boolean] :include_defaults If `true`, return all default settings in the response.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-get-mapping
        #
        def get_field_mapping(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.get_field_mapping' }

          defined_params = [:fields, :index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'fields' missing" unless arguments[:fields]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _fields = arguments.delete(:fields)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index && _fields
                     "#{Utils.listify(_index)}/_mapping/field/#{Utils.listify(_fields)}"
                   else
                     "_mapping/field/#{Utils.listify(_fields)}"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
