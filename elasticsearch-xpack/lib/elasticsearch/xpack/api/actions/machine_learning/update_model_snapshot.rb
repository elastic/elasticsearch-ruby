# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :job_id The ID of the job to fetch
          # @option arguments [String] :snapshot_id The ID of the snapshot to update

          # @option arguments [Hash] :body The model snapshot properties to update (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-update-snapshot.html
          #
          def update_model_snapshot(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            _snapshot_id = arguments.delete(:snapshot_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/model_snapshots/#{Elasticsearch::API::Utils.__listify(_snapshot_id)}/_update"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
