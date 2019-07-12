# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Predict the future behavior of a time series
          #
          # @option arguments [String] :job_id The ID of the job to forecast for (*Required*)
          # @option arguments [Time] :duration The duration of the forecast
          # @option arguments [Time] :expires_in The time interval after which the forecast expires. Expired forecasts will be deleted at the first opportunity.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-forecast.html
          #
          def forecast(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            valid_params = [
              :duration,
              :expires_in ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{arguments[:job_id]}/_forecast"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
