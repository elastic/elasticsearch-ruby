# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Starts a data frame analytics job.
          #
          # @option arguments [String] :id The ID of the data frame analytics to start
          # @option arguments [Time] :timeout Controls the time to wait until the task has started. Defaults to 20 seconds

          # @option arguments [Hash] :body The start data frame analytics parameters
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/start-dfanalytics.html
          #
          def start_data_frame_analytics(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}/_start"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:start_data_frame_analytics, [
            :timeout
          ].freeze)
      end
    end
    end
  end
end
