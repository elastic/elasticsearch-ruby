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
        # Get anomaly detection job results for buckets.
        # The API presents a chronological view of the records, grouped by bucket.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [String, Time] :timestamp The timestamp of a single bucket result. If you do not specify this
        #  parameter, the API returns information about all buckets.
        # @option arguments [Float] :anomaly_score Returns buckets with anomaly scores greater or equal than this value. Server default: 0.
        # @option arguments [Boolean] :desc If `true`, the buckets are sorted in descending order.
        # @option arguments [String, Time] :end Returns buckets with timestamps earlier than this time. `-1` means it is
        #  unset and results are not limited to specific timestamps. Server default: -1.
        # @option arguments [Boolean] :exclude_interim If `true`, the output excludes interim results.
        # @option arguments [Boolean] :expand If true, the output includes anomaly records.
        # @option arguments [Integer] :from Skips the specified number of buckets. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of buckets to obtain. Server default: 100.
        # @option arguments [String] :sort Specifies the sort field for the requested buckets. Server default: timestamp.
        # @option arguments [String, Time] :start Returns buckets with timestamps after this time. `-1` means it is unset
        #  and results are not limited to specific timestamps. Server default: -1.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-buckets
        #
        def get_buckets(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_buckets' }

          defined_params = [:job_id, :timestamp].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          _timestamp = arguments.delete(:timestamp)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _job_id && _timestamp
                     "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/results/buckets/#{Utils.listify(_timestamp)}"
                   else
                     "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/results/buckets"
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
