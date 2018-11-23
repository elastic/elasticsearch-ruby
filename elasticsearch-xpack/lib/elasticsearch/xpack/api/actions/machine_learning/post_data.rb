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

          # Send data to an anomaly detection job for analysis
          #
          # @option arguments [String] :job_id The name of the job receiving the data (*Required*)
          # @option arguments [Hash] :body The data to process (*Required*)
          # @option arguments [String] :reset_start Optional parameter to specify the start of the bucket resetting range
          # @option arguments [String] :reset_end Optional parameter to specify the end of the bucket resetting range
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-post-data.html
          #
          def post_data(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            valid_params = [
              :reset_start,
              :reset_end ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_data"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
