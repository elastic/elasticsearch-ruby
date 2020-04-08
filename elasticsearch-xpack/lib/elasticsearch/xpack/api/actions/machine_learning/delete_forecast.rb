# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Deletes forecasts from a machine learning job.
          #
          # @option arguments [String] :job_id The ID of the job from which to delete forecasts
          # @option arguments [String] :forecast_id The ID of the forecast to delete, can be comma delimited list. Leaving blank implies `_all`
          # @option arguments [Boolean] :allow_no_forecasts Whether to ignore if `_all` matches no forecasts
          # @option arguments [Time] :timeout Controls the time to wait until the forecast(s) are deleted. Default to 30 seconds
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-delete-forecast.html
          #
          def delete_forecast(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            _forecast_id = arguments.delete(:forecast_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = if _job_id && _forecast_id
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/_forecast/#{Elasticsearch::API::Utils.__listify(_forecast_id)}"
                     else
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/_forecast"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:delete_forecast, [
            :allow_no_forecasts,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
