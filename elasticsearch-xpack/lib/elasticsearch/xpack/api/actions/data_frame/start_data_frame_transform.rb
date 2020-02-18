# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions
          # Start a data frame analytics job.
          #
          # @option arguments [String] :transform_id The id of the transform to start. *Required*
          # @option arguments [String] :timeout Controls the time to wait for the transform to start.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/start-data-frame-transform.html
          #
          # @since 7.2.0
          def start_data_frame_transform(arguments = {})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            arguments = arguments.clone
            transform_id = URI.escape(arguments.delete(:transform_id))

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/#{transform_id}/_start"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:start_data_frame_transform, [:timeout].freeze)
        end
      end
    end
  end
end
