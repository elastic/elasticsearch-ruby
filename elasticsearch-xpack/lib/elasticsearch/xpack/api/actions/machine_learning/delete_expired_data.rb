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
      module MachineLearning
        module Actions
          # Deletes expired and unused machine learning data.
          #
          # @option arguments [String] :job_id The ID of the job(s) to perform expired data hygiene for
          # @option arguments [Number] :requests_per_second The desired requests per second for the deletion processes.
          # @option arguments [Time] :timeout How long can the underlying delete processes run until they are canceled
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body deleting expired data parameters
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.9/ml-delete-expired-data.html
          #
          def delete_expired_data(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = if _job_id
                       "_ml/_delete_expired_data/#{Elasticsearch::API::Utils.__listify(_job_id)}"
                     else
                       "_ml/_delete_expired_data"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:delete_expired_data, [
            :requests_per_second,
            :timeout
          ].freeze)
        end
      end
    end
  end
end
