module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Update certain properties of a job
          #
          # @option arguments [String] :job_id The ID of the job to create (*Required*)
          # @option arguments [Hash] :body The job update settings (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-update-job.html
          #
          def update_job(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_update"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
