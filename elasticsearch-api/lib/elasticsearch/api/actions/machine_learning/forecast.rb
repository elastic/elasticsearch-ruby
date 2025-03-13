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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Predict future behavior of a time series.
        # Forecasts are not supported for jobs that perform population analysis; an
        # error occurs if you try to create a forecast for a job that has an
        # +over_field_name+ in its configuration. Forcasts predict future behavior
        # based on historical data.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. The job must be open when you
        #  create a forecast; otherwise, an error occurs. (*Required*)
        # @option arguments [Time] :duration A period of time that indicates how far into the future to forecast. For
        #  example, +30d+ corresponds to 30 days. The forecast starts at the last
        #  record that was processed. Server default: 1d.
        # @option arguments [Time] :expires_in The period of time that forecast results are retained. After a forecast
        #  expires, the results are deleted. If set to a value of 0, the forecast is
        #  never automatically deleted. Server default: 14d.
        # @option arguments [String] :max_model_memory The maximum memory the forecast can use. If the forecast needs to use
        #  more than the provided amount, it will spool to disk. Default is 20mb,
        #  maximum is 500mb and minimum is 1mb. If set to 40% or more of the job’s
        #  configured memory limit, it is automatically reduced to below that
        #  amount. Server default: 20mb.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-forecast
        #
        def forecast(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.forecast' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/_forecast"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
