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

          # Force any buffered data to be processed by the job
          #
          # @option arguments [String] :job_id The name of the job to flush (*Required*)
          # @option arguments [Hash] :body Flush parameters
          # @option arguments [Boolean] :calc_interim Calculates interim results for the most recent bucket or all buckets within the latency period
          # @option arguments [String] :start When used in conjunction with calc_interim, specifies the range of buckets on which to calculate interim results
          # @option arguments [String] :end When used in conjunction with calc_interim, specifies the range of buckets on which to calculate interim results
          # @option arguments [String] :advance_time Setting this tells the Engine API that no data prior to advance_time is expected
          # @option arguments [String] :skip_time Skips time to the given value without generating results or updating the model for the skipped interval
          #
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-flush-job.html
          #
          def flush_job(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            valid_params = [
              :calc_interim,
              :start,
              :end,
              :advance_time,
              :skip_time ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{arguments[:job_id]}/_flush"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
