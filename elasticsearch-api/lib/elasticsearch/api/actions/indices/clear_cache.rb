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
        # Clear the cache.
        # Clear the cache of one or more indices.
        # For data streams, the API clears the caches of the stream's backing indices.
        # By default, the clear cache API clears all caches.
        # To clear only specific caches, use the +fielddata+, +query+, or +request+ parameters.
        # To clear the cache only of specific fields, use the +fields+ parameter.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit the request.
        #  Supports wildcards (+*+).
        #  To target all data streams and indices, omit this parameter or use +*+ or +_all+.
        # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as +open,hidden+.
        #  Valid values are: +all+, +open+, +closed+, +hidden+, +none+. Server default: open.
        # @option arguments [Boolean] :fielddata If +true+, clears the fields cache.
        #  Use the +fields+ parameter to clear the cache of specific fields only.
        # @option arguments [String, Array<String>] :fields Comma-separated list of field names used to limit the +fielddata+ parameter.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
        # @option arguments [Boolean] :query If +true+, clears the query cache.
        # @option arguments [Boolean] :request If +true+, clears the request cache.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-clear-cache
        #
        def clear_cache(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.clear_cache' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "#{Utils.listify(_index)}/_cache/clear"
                   else
                     '_cache/clear'
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
