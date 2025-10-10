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
        # Get anomaly records for an anomaly detection job.
        # Records contain the detailed analytical results. They describe the anomalous
        # activity that has been identified in the input data based on the detector
        # configuration.
        # There can be many anomaly records depending on the characteristics and size
        # of the input data. In practice, there are often too many to be able to
        # manually process them. The machine learning features therefore perform a
        # sophisticated aggregation of the anomaly records into buckets.
        # The number of record results depends on the number of anomalies found in each
        # bucket, which relates to the number of time series being modeled and the
        # number of detectors.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [Boolean] :desc If true, the results are sorted in descending order.
        # @option arguments [String, Time] :end Returns records with timestamps earlier than this time. The default value
        #  means results are not limited to specific timestamps. Server default: -1.
        # @option arguments [Boolean] :exclude_interim If `true`, the output excludes interim results.
        # @option arguments [Integer] :from Skips the specified number of records. Server default: 0.
        # @option arguments [Float] :record_score Returns records with anomaly scores greater or equal than this value. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of records to obtain. Server default: 100.
        # @option arguments [String] :sort Specifies the sort field for the requested records. Server default: record_score.
        # @option arguments [String, Time] :start Returns records with timestamps after this time. The default value means
        #  results are not limited to specific timestamps. Server default: -1.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-records
        #
        def get_records(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_records' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/results/records"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
