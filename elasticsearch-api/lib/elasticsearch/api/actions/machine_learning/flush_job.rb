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
        # Forces any buffered data to be processed by the job.
        #
        # @option arguments [String] :job_id The name of the job to flush
        # @option arguments [Boolean] :calc_interim Calculates interim results for the most recent bucket or all buckets within the latency period
        # @option arguments [String] :start When used in conjunction with calc_interim, specifies the range of buckets on which to calculate interim results
        # @option arguments [String] :end When used in conjunction with calc_interim, specifies the range of buckets on which to calculate interim results
        # @option arguments [String] :advance_time Advances time to the given value generating results and updating the model for the advanced interval
        # @option arguments [String] :skip_time Skips time to the given value without generating results or updating the model for the skipped interval
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Flush parameters
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ml-flush-job.html
        #
        def flush_job(arguments = {})
          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/_flush"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
