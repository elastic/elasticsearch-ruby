# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Update certain properties of a snapshot
          #
          # @option arguments [String] :job_id The ID of the job to fetch (*Required*)
          # @option arguments [String] :snapshot_id The ID of the snapshot to update (*Required*)
          # @option arguments [Hash] :body The model snapshot properties to update (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-update-snapshot.html
          #
          def update_model_snapshot(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/model_snapshots/#{arguments[:snapshot_id]}/_update"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
