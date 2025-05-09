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
    module Actions
      # Get the field capabilities.
      # Get information about the capabilities of fields among multiple indices.
      # For data streams, the API returns field capabilities among the stream’s backing indices.
      # It returns runtime fields like any other field.
      # For example, a runtime field with a type of keyword is returned the same as any other field that belongs to the `keyword` family.
      #
      # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases used to limit the request. Supports wildcards (*). To target all data streams and indices, omit this parameter or use * or _all.
      # @option arguments [Boolean] :allow_no_indices If false, the request returns an error if any wildcard expression, index alias,
      #  or `_all` value targets only missing or closed indices. This behavior applies even if the request targets other open indices. For example, a request
      #  targeting `foo*,bar*` returns an error if an index starts with foo but no index starts with bar. Server default: true.
      # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match. If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams. Supports comma-separated values, such as `open,hidden`. Server default: open.
      # @option arguments [String, Array<String>] :fields A comma-separated list of fields to retrieve capabilities for. Wildcard (`*`) expressions are supported.
      # @option arguments [Boolean] :ignore_unavailable If `true`, missing or closed indices are not included in the response.
      # @option arguments [Boolean] :include_unmapped If true, unmapped fields are included in the response.
      # @option arguments [String] :filters A comma-separated list of filters to apply to the response.
      # @option arguments [Array<String>] :types A comma-separated list of field types to include.
      #  Any fields that do not match one of these types will be excluded from the results.
      #  It defaults to empty, meaning that all field types are returned.
      # @option arguments [Boolean] :include_empty_fields If false, empty fields are not included in the response. Server default: true.
      # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
      #  when they occur.
      # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
      #  returned by Elasticsearch.
      # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
      #  For example `"exists_time": "1h"` for humans and
      #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
      #  readable values will be omitted. This makes sense for responses being consumed
      #  only by machines.
      # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
      #  this option for debugging only.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-field-caps
      #
      def field_caps(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'field_caps' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = if _index
                   "#{Utils.listify(_index)}/_field_caps"
                 else
                   '_field_caps'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
