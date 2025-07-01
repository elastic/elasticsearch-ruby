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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Delete forecasts from a job.
        # By default, forecasts are retained for 14 days. You can specify a
        # different retention period with the `expires_in` parameter in the forecast
        # jobs API. The delete forecast API enables you to delete one or more
        # forecasts before they expire.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [String] :forecast_id A comma-separated list of forecast identifiers. If you do not specify
        #  this optional parameter or if you specify `_all` or `*` the API deletes
        #  all forecasts from the job.
        # @option arguments [Boolean] :allow_no_forecasts Specifies whether an error occurs when there are no forecasts. In
        #  particular, if this parameter is set to `false` and there are no
        #  forecasts associated with the job, attempts to delete all forecasts
        #  return an error. Server default: true.
        # @option arguments [Time] :timeout Specifies the period of time to wait for the completion of the delete
        #  operation. When this period of time elapses, the API fails and returns an
        #  error. Server default: 30s.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-delete-forecast
        #
        def delete_forecast(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_forecast' }

          defined_params = [:job_id, :forecast_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _job_id = arguments.delete(:job_id)

          _forecast_id = arguments.delete(:forecast_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = if _job_id && _forecast_id
                     "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/_forecast/#{Utils.listify(_forecast_id)}"
                   else
                     "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/_forecast"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
