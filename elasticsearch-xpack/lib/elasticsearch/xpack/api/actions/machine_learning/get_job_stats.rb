module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :job_id The ID of the jobs stats to fetch
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/ml-get-job-stats.html
          #
          def get_job_stats(arguments={})
            valid_params = [
              :allow_no_jobs ]

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_stats"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
