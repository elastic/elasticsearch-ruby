# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieve information about model snapshots
          #
          # @option arguments [String] :job_id The ID of the job to fetch (*Required*)
          # @option arguments [String] :snapshot_id The ID of the snapshot to fetch
          # @option arguments [Hash] :body Model snapshot selection criteria
          # @option arguments [Integer] :from Skips a number of documents
          # @option arguments [Integer] :size The default number of documents returned in queries as a string.
          # @option arguments [Date] :start The filter 'start' query parameter
          # @option arguments [Date] :end The filter 'end' query parameter
          # @option arguments [String] :sort Name of the field to sort on
          # @option arguments [Boolean] :desc True if the results should be sorted in descending order
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-snapshot.html
          #
          def get_model_snapshots(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/model_snapshots/#{arguments[:snapshot_id]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_model_snapshots, [:from,
                                                         :size,
                                                         :start,
                                                         :end,
                                                         :sort,
                                                         :desc].freeze)
        end
      end
    end
  end
end
