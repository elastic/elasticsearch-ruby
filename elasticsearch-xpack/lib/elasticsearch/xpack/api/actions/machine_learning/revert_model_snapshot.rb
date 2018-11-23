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
      module MachineLearning
        module Actions

          # Revert to a specific snapshot (eg. before a highly-anomalous, but insignificant event)
          #
          # @option arguments [String] :job_id The ID of the job to fetch (*Required*)
          # @option arguments [String] :snapshot_id The ID of the snapshot to revert to
          # @option arguments [Hash] :body Reversion options
          # @option arguments [Boolean] :delete_intervening_results Should we reset the results back to the time of the snapshot?
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-revert-snapshot.html
          #
          def revert_model_snapshot(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            valid_params = [
              :delete_intervening_results ]

            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify "_xpack/ml/anomaly_detectors", arguments[:job_id], "model_snapshots", arguments[:snapshot_id], "_revert"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
