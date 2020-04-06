# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieves information about model snapshots.
          #
          # @option arguments [String] :job_id The ID of the job to fetch
          # @option arguments [String] :snapshot_id The ID of the snapshot to fetch
          # @option arguments [Int] :from Skips a number of documents
          # @option arguments [Int] :size The default number of documents returned in queries as a string.
          # @option arguments [Date] :start The filter 'start' query parameter
          # @option arguments [Date] :end The filter 'end' query parameter
          # @option arguments [String] :sort Name of the field to sort on
          # @option arguments [Boolean] :desc True if the results should be sorted in descending order

          # @option arguments [Hash] :body Model snapshot selection criteria
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-snapshot.html
          #
          def get_model_snapshots(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            _snapshot_id = arguments.delete(:snapshot_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _job_id && _snapshot_id
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/model_snapshots/#{Elasticsearch::API::Utils.__listify(_snapshot_id)}"
                     else
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/model_snapshots"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_model_snapshots, [
            :from,
            :size,
            :start,
            :end,
            :sort,
            :desc
          ].freeze)
      end
    end
    end
  end
end
