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
        # Force buffered data to be processed.
        # The flush jobs API is only applicable when sending data for analysis using
        # the post data API. Depending on the content of the buffer, then it might
        # additionally calculate new results. Both flush and close operations are
        # similar, however the flush is more efficient if you are expecting to send
        # more data for analysis. When flushing, the job remains open and is available
        # to continue analyzing data. A close operation additionally prunes and
        # persists the model state to disk and the job must be opened again before
        # analyzing further data.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [String, Time] :advance_time Specifies to advance to a particular time value. Results are generated
        #  and the model is updated for data from the specified time interval.
        # @option arguments [Boolean] :calc_interim If true, calculates the interim results for the most recent bucket or all
        #  buckets within the latency period.
        # @option arguments [String, Time] :end When used in conjunction with `calc_interim` and `start`, specifies the
        #  range of buckets on which to calculate interim results.
        # @option arguments [String, Time] :skip_time Specifies to skip to a particular time value. Results are not generated
        #  and the model is not updated for data from the specified time interval.
        # @option arguments [String, Time] :start When used in conjunction with `calc_interim`, specifies the range of
        #  buckets on which to calculate interim results.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-flush-job
        #
        def flush_job(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.flush_job' }

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
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/_flush"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
