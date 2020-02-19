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
          # @option arguments [String] :id The ID of the data frame analytics to stop
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no data frame analytics. (This includes `_all` string or when no data frame analytics have been specified)
          # @option arguments [Boolean] :force True if the data frame analytics should be forcefully stopped
          # @option arguments [Time] :timeout Controls the time to wait until the task has stopped. Defaults to 20 seconds

          # @option arguments [Hash] :body The stop data frame analytics parameters
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/stop-dfanalytics.html
          #
          def stop_data_frame_analytics(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:stop_data_frame_analytics, [
            :allow_no_match,
            :force,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
