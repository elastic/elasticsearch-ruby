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
    module Monitoring
      module Actions
        # Used by the monitoring features to send monitoring data.
        #
        # @option arguments [String] :type Default document type for items which don't provide one *Deprecated*
        # @option arguments [String] :system_id Identifier of the monitored system
        # @option arguments [String] :system_api_version API Version of the monitored system
        # @option arguments [String] :interval Collection interval (e.g., '10s' or '10000ms') of the payload
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [String|Array] :body The operation definition and data (action-data pairs), separated by newlines. Array of Strings, Header/Data pairs,
        # or the conveniency "combined" format can be passed, refer to Elasticsearch::API::Utils.__bulkify documentation.
        #
        # *Deprecation notice*:
        # Specifying types in urls has been deprecated
        # Deprecated since version 7.0.0
        #
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/monitor-elasticsearch-cluster.html
        #
        def bulk(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'monitoring.bulk' }

          defined_params = [:type].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _type = arguments.delete(:type)

          method = Elasticsearch::API::HTTP_POST
          path   = if _type
                     "_monitoring/#{Utils.__listify(_type)}/bulk"
                   else
                     '_monitoring/bulk'
                   end
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
