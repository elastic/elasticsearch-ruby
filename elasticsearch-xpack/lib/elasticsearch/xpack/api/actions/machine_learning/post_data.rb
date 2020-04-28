# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Sends data to an anomaly detection job for analysis.
          #
          # @option arguments [String] :job_id The name of the job receiving the data
          # @option arguments [String] :reset_start Optional parameter to specify the start of the bucket resetting range
          # @option arguments [String] :reset_end Optional parameter to specify the end of the bucket resetting range
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The data to process (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/ml-post-data.html
          #
          def post_data(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/_data"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:post_data, [
            :reset_start,
            :reset_end
          ].freeze)
      end
    end
    end
  end
end
