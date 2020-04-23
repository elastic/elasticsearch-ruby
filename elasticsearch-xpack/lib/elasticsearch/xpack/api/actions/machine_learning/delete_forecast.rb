# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # @option arguments [String] :job_id The ID of the job from which to delete forecasts (*Required*)
          # @option arguments [String] :forecast_id The ID of the forecast to delete, can be comma delimited list.
          #   Leaving blank implies `_all`
          # @option arguments [Boolean] :allow_no_forecasts Whether to ignore if `_all` matches no forecasts
          # @option arguments [Time] :timeout Controls the time to wait until the forecast(s) are deleted.
          #   Default to 30 seconds.
          #
          def delete_forecast(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_forecast/#{arguments[:forecast_id]}"

            valid_params = [
                :forecast_id,
                :allow_no_forecasts,
                :timeout ]

            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
