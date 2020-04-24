# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
