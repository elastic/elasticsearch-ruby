# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
