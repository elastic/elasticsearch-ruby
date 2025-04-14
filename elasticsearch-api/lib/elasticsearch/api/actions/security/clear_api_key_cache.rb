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
    module Security
      module Actions
        # Clear the API key cache.
        # Evict a subset of all entries from the API key cache.
        # The cache is also automatically cleared on state changes of the security index.
        #
        # @option arguments [String, Array] :ids Comma-separated list of API key IDs to evict from the API key cache.
        #  To evict all API keys, use +*+.
        #  Does not support other wildcard patterns. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-security-clear-api-key-cache
        #
        def clear_api_key_cache(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.clear_api_key_cache' }

          defined_params = [:ids].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'ids' missing" unless arguments[:ids]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _ids = arguments.delete(:ids)

          method = Elasticsearch::API::HTTP_POST
          path   = "_security/api_key/#{Utils.listify(_ids)}/_clear_cache"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
