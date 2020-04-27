# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Create a new job
          #
          # @option arguments [String] :job_id The ID of the job to create (*Required*)
          # @option arguments [Hash] :body The job (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-put-job.html
          #
          def put_job(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
