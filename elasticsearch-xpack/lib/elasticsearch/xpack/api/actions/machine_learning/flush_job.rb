# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
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
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-flush-job.html
          #
          def flush_job(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/_flush"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:flush_job, [
            :calc_interim,
            :start,
            :end,
            :advance_time,
            :skip_time
          ].freeze)
      end
    end
    end
  end
end
