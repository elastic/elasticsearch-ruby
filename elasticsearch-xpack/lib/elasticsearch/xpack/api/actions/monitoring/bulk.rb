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
  module XPack
    module API
      module Monitoring
        module Actions
          # Used by the monitoring features to send monitoring data.
          #
          # @option arguments [String] :type Default document type for items which don't provide one   *Deprecated*
          # @option arguments [String] :system_id Identifier of the monitored system
          # @option arguments [String] :system_api_version API Version of the monitored system
          # @option arguments [String] :interval Collection interval (e.g., '10s' or '10000ms') of the payload
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The operation definition and data (action-data pairs), separated by newlines (*Required*)
          #
          # *Deprecation notice*:
          # Specifying types in urls has been deprecated
          # Deprecated since version 7.0.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/monitor-elasticsearch-cluster.html
          #
          def bulk(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _type = arguments.delete(:type)

            method = Elasticsearch::API::HTTP_POST
            path   = if _type
                       "_monitoring/#{Elasticsearch::API::Utils.__listify(_type)}/bulk"
                     else
                       "_monitoring/bulk"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            if body.is_a? Array
              payload = Elasticsearch::API::Utils.__bulkify(body)
            else
              payload = body
          end

            headers.merge!("Content-Type" => "application/x-ndjson")
            perform_request(method, path, params, payload, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:bulk, [
            :system_id,
            :system_api_version,
            :interval
          ].freeze)
      end
    end
    end
  end
end
