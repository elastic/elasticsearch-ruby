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

          # Retrieve overall bucket results that summarize the bucket results of multiple jobs
          #
          # @option arguments [String] :job_id The job IDs for which to calculate overall bucket results (*Required*)
          # @option arguments [Hash] :body Overall bucket selection details if not provided in URI
          # @option arguments [Int] :top_n The number of top job bucket scores to be used in the overall_score calculation
          # @option arguments [String] :bucket_span The span of the overall buckets. Defaults to the longest job bucket_span
          # @option arguments [Double] :overall_score Returns overall buckets with overall scores higher than this value
          # @option arguments [Boolean] :exclude_interim If true overall buckets that include interim buckets will be excluded
          # @option arguments [String] :start Returns overall buckets with timestamps after this time
          # @option arguments [String] :end Returns overall buckets with timestamps earlier than this time
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-overall-buckets.html
          #
          def get_overall_buckets(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            valid_params = [
              :top_n,
              :bucket_span,
              :overall_score,
              :exclude_interim,
              :start,
              :end,
              :allow_no_jobs ]

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/results/overall_buckets"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
