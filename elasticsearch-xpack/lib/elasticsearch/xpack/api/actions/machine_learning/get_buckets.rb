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
          # @option arguments [String] :job_id ID of the job to get bucket results from
          # @option arguments [String] :timestamp The timestamp of the desired single bucket result
          # @option arguments [Boolean] :expand Include anomaly records
          # @option arguments [Boolean] :exclude_interim Exclude interim results
          # @option arguments [Int] :from skips a number of buckets
          # @option arguments [Int] :size specifies a max number of buckets to get
          # @option arguments [String] :start Start time filter for buckets
          # @option arguments [String] :end End time filter for buckets
          # @option arguments [Double] :anomaly_score Filter for the most anomalous buckets
          # @option arguments [String] :sort Sort buckets by a particular field
          # @option arguments [Boolean] :desc Set the sort direction

          # @option arguments [Hash] :body Bucket selection details if not provided in URI
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-bucket.html
          #
          def get_buckets(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            _timestamp = arguments.delete(:timestamp)

            method = Elasticsearch::API::HTTP_GET
            path   = if _job_id && _timestamp
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/results/buckets/#{Elasticsearch::API::Utils.__listify(_timestamp)}"
                     else
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/results/buckets"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_buckets, [
            :expand,
            :exclude_interim,
            :from,
            :size,
            :start,
            :end,
            :anomaly_score,
            :sort,
            :desc
          ].freeze)
      end
    end
    end
  end
end
