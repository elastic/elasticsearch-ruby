# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
