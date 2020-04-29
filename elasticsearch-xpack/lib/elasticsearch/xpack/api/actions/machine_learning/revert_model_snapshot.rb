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
          # Reverts to a specific snapshot.
          #
          # @option arguments [String] :job_id The ID of the job to fetch
          # @option arguments [String] :snapshot_id The ID of the snapshot to revert to
          # @option arguments [Boolean] :delete_intervening_results Should we reset the results back to the time of the snapshot?
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Reversion options
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-revert-snapshot.html
          #
          def revert_model_snapshot(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            _snapshot_id = arguments.delete(:snapshot_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/model_snapshots/#{Elasticsearch::API::Utils.__listify(_snapshot_id)}/_revert"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:revert_model_snapshot, [
            :delete_intervening_results
          ].freeze)
      end
    end
    end
  end
end
