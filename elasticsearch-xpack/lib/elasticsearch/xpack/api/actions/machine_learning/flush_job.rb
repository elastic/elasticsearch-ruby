# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{arguments[:job_id]}/_flush"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:flush_job, [ :calc_interim,
                                                :start,
                                                :end,
                                                :advance_time,
                                                :skip_time ].freeze)
        end
      end
    end
  end
end
