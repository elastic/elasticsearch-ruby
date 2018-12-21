# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

          # Insert monitoring data in bulk
          #
          # @option arguments [String] :type Default document type for items which don't provide one
          # @option arguments [Hash] :body The operation definition and data (action-data pairs), separated by newlines (*Required*)
          # @option arguments [String] :system_id Identifier of the monitored system
          # @option arguments [String] :system_api_version API version of the monitored system
          # @option arguments [String] :system_version Version of the monitored system
          #
          # @see http://www.elastic.co/guide/en/monitoring/current/appendix-api-bulk.html
          #
          def bulk(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            valid_params = [
              :system_id,
              :system_api_version,
              :system_version,
              :interval ]

            arguments = arguments.clone
            type = arguments.delete(:type)
            body = arguments.delete(:body)

            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify '_xpack/monitoring', type, '_bulk'
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params

            if body.is_a? Array
              payload = Elasticsearch::API::Utils.__bulkify(body)
            else
              payload = body
            end

            perform_request(method, path, params, payload).body
          end
        end
      end
    end
  end
end
