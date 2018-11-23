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

          # TODO: Description
          #
          # @option arguments [String] :job_id The name of the job to close (*Required*)
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          # @option arguments [Boolean] :force True if the job should be forcefully closed
          # @option arguments [Time] :timeout Controls the time to wait until a job has closed. Default to 30 minutes
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-close-job.html
          #
          def close_job(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            valid_params = [
              :allow_no_jobs,
              :force,
              :timeout ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_close"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
