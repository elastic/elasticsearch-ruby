module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Delete an existing model snapshot
          #
          # @option arguments [String] :job_id The ID of the job to fetch (*Required*)
          # @option arguments [String] :snapshot_id The ID of the snapshot to delete (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-delete-snapshot.html
          #
          def delete_model_snapshot(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/model_snapshots/#{arguments[:snapshot_id]}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
