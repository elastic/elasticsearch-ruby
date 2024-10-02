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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Actions
      # Returns the information about the capabilities of fields among multiple indices.
      #
      # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
      # @option arguments [List] :fields A comma-separated list of field names
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, hidden, none, all)
      # @option arguments [Boolean] :include_unmapped Indicates whether unmapped fields should be included in the response.
      # @option arguments [List] :filters An optional set of filters: can include +metadata,-metadata,-nested,-multifield,-parent
      # @option arguments [List] :types Only return results for fields that have one of the types in the list
      # @option arguments [Boolean] :include_empty_fields Include empty fields in result
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body An index filter specified with the Query DSL
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/search-field-caps.html
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

        path = if _index
                 "#{Utils.__listify(_index)}/_field_caps"
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
