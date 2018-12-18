module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # @option arguments [String] :job_id The ID of the filter to delete (*Required*)
          #
          def delete_forecast(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_forecast/#{arguments[:forecast_id]}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
