# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Closes one or more anomaly detection jobs. A job can be opened and closed multiple times throughout its lifecycle.
          #
          # @option arguments [String] :job_id The name of the job to close
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          # @option arguments [Boolean] :force True if the job should be forcefully closed
          # @option arguments [Time] :timeout Controls the time to wait until a job has closed. Default to 30 minutes
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The URL params optionally sent in the body
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-close-job.html
          #
          def close_job(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/_close"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:close_job, [
            :allow_no_jobs,
            :force,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
