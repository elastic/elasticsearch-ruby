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
    module Security
      module Actions
        # Clear a subset or all entries from the API key cache.
        #
        # @option arguments [List] :ids A comma-separated list of IDs of API keys to clear from the cache
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.2/security-api-clear-api-key-cache.html
        #
        def clear_api_key_cache(arguments = {})
          raise ArgumentError, "Required argument 'ids' missing" unless arguments[:ids]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          _ids = arguments.delete(:ids)

          method = Elasticsearch::API::HTTP_POST
          path   = "_security/api_key/#{Utils.__listify(_ids)}/_clear_cache"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
