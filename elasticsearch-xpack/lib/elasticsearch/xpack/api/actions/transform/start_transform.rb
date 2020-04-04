# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Transform
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :transform_id The id of the transform to start
          # @option arguments [Time] :timeout Controls the time to wait for the transform to start

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/start-transform.html
          #
          def start_transform(arguments = {})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_transform/#{Elasticsearch::API::Utils.__listify(_transform_id)}/_start"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:start_transform, [
            :timeout
          ].freeze)
      end
    end
    end
  end
end
