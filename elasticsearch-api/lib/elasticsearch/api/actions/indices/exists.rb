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
        # Check indices.
        # Check if one or more indices, index aliases, or data streams exist.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases. Supports wildcards (+*+). (*Required*)
        # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as +open,hidden+.
        #  Valid values are: +all+, +open+, +closed+, +hidden+, +none+. Server default: open.
        # @option arguments [Boolean] :flat_settings If +true+, returns settings in flat format.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
        # @option arguments [Boolean] :include_defaults If +true+, return all default settings in the response.
        # @option arguments [Boolean] :local If +true+, the request retrieves information from the local node only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-exists
        #
        def exists(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.exists' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_HEAD
          path   = Utils.listify(_index).to_s
          params = Utils.process_params(arguments)

          Utils.rescue_from_not_found do
            perform_request(method, path, params, body, headers, request_opts).status == 200
          end
        end

        alias exists? exists
      end
    end
  end
end
