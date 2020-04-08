# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieves overall bucket results that summarize the bucket results of multiple anomaly detection jobs.
          #
          # @option arguments [String] :job_id The job IDs for which to calculate overall bucket results
          # @option arguments [Int] :top_n The number of top job bucket scores to be used in the overall_score calculation
          # @option arguments [String] :bucket_span The span of the overall buckets. Defaults to the longest job bucket_span
          # @option arguments [Double] :overall_score Returns overall buckets with overall scores higher than this value
          # @option arguments [Boolean] :exclude_interim If true overall buckets that include interim buckets will be excluded
          # @option arguments [String] :start Returns overall buckets with timestamps after this time
          # @option arguments [String] :end Returns overall buckets with timestamps earlier than this time
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Overall bucket selection details if not provided in URI
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-overall-buckets.html
          #
          def get_overall_buckets(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/results/overall_buckets"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_overall_buckets, [
            :top_n,
            :bucket_span,
            :overall_score,
            :exclude_interim,
            :start,
            :end,
            :allow_no_jobs
          ].freeze)
      end
    end
    end
  end
end
