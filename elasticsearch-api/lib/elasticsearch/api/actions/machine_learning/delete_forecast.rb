# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
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
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ml-delete-forecast.html
        #
        def delete_forecast(arguments = {})
          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _job_id = arguments.delete(:job_id)

          _forecast_id = arguments.delete(:forecast_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = if _job_id && _forecast_id
                     "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/_forecast/#{Utils.__listify(_forecast_id)}"
                   else
                     "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/_forecast"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
