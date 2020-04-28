# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieves anomaly records for an anomaly detection job.
          #
          # @option arguments [String] :job_id The ID of the job
          # @option arguments [Boolean] :exclude_interim Exclude interim results
          # @option arguments [Int] :from skips a number of records
          # @option arguments [Int] :size specifies a max number of records to get
          # @option arguments [String] :start Start time filter for records
          # @option arguments [String] :end End time filter for records
          # @option arguments [Double] :record_score Returns records with anomaly scores greater or equal than this value
          # @option arguments [String] :sort Sort records by a particular field
          # @option arguments [Boolean] :desc Set the sort direction
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Record selection criteria
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/ml-get-record.html
          #
          def get_records(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/results/records"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_records, [
            :exclude_interim,
            :from,
            :size,
            :start,
            :end,
            :record_score,
            :sort,
            :desc
          ].freeze)
      end
    end
    end
  end
end
