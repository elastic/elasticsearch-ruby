# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrameTransformDeprecated
        module Actions
          # Stops one or more transforms.
          #
          # @option arguments [String] :transform_id The id of the transform to stop
          # @option arguments [Boolean] :wait_for_completion Whether to wait for the transform to fully stop before returning or not. Default to false
          # @option arguments [Time] :timeout Controls the time to wait until the transform has stopped. Default to 30 seconds
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # *Deprecation notice*:
          # [_data_frame/transforms/] is deprecated, use [_transform/] in the future.
          # Deprecated since version 7.5.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/stop-transform.html
          #
          def stop_transform(arguments = {})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/#{Elasticsearch::API::Utils.__listify(_transform_id)}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:stop_transform, [
            :wait_for_completion,
            :timeout,
            :allow_no_match
          ].freeze)
      end
    end
    end
  end
end
