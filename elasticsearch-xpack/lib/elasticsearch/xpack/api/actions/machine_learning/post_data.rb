# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Send data to an anomaly detection job for analysis
          #
          # @option arguments [String] :job_id The name of the job receiving the data (*Required*)
          # @option arguments [Hash] :body The data to process (*Required*)
          # @option arguments [String] :reset_start Optional parameter to specify the start of the bucket resetting range
          # @option arguments [String] :reset_end Optional parameter to specify the end of the bucket resetting range
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-post-data.html
          #
          def post_data(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/_data"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:post_data, [:reset_start,
                                               :reset_end].freeze)
        end
      end
    end
  end
end
