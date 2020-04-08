# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Deletes an existing model snapshot.
          #
          # @option arguments [String] :job_id The ID of the job to fetch
          # @option arguments [String] :snapshot_id The ID of the snapshot to delete
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-delete-snapshot.html
          #
          def delete_model_snapshot(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            _snapshot_id = arguments.delete(:snapshot_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/model_snapshots/#{Elasticsearch::API::Utils.__listify(_snapshot_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
