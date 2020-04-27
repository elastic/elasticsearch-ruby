# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Retrieve anomaly records for a job
          #
          # @option arguments [String] :job_id [TODO] (*Required*)
          # @option arguments [Hash] :body Record selection criteria
          # @option arguments [Boolean] :exclude_interim Exclude interim results
          # @option arguments [Int] :from skips a number of records
          # @option arguments [Int] :size specifies a max number of records to get
          # @option arguments [String] :start Start time filter for records
          # @option arguments [String] :end End time filter for records
          # @option arguments [Double] :record_score [TODO]
          # @option arguments [String] :sort Sort records by a particular field
          # @option arguments [Boolean] :desc Set the sort direction
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-record.html
          #
          def get_records(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            valid_params = [
              :exclude_interim,
              :from,
              :size,
              :start,
              :end,
              :record_score,
              :sort,
              :desc ]

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/results/records"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
