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
# Auto generated from build hash 589cd632d091bc0a512c46d5d81ac1f961b60127
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Monitoring
      module Actions
        # Send monitoring data
        #
        # @option arguments [String] :system_id Identifier of the monitored system (*Required*)
        # @option arguments [String] :system_api_version API Version of the monitored system (*Required*)
        # @option arguments [Time] :interval Collection interval (e.g., '10s' or '10000ms') of the payload (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [String|Array] :body The operation definition and data (action-data pairs), separated by newlines. Array of Strings, Header/Data pairs,
        # or the conveniency "combined" format can be passed, refer to Elasticsearch::API::Utils.__bulkify documentation.
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v8
        #
        def bulk(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'monitoring.bulk' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_monitoring/bulk'
          params = Utils.process_params(arguments)

          payload = if body.is_a? Array
                      Elasticsearch::API::Utils.__bulkify(body)
                    else
                      body
                    end

          headers.merge!('Content-Type' => 'application/x-ndjson')
          Elasticsearch::API::Response.new(
            perform_request(method, path, params, payload, headers, request_opts)
          )
        end
      end
    end
  end
end
