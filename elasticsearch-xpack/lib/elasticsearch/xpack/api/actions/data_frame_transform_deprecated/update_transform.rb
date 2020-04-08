# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrameTransformDeprecated
        module Actions
          # Updates certain properties of a transform.
          #
          # @option arguments [String] :transform_id The id of the transform.  (*Required*)
          # @option arguments [Boolean] :defer_validation If validations should be deferred until transform starts, defaults to false.
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The update transform definition (*Required*)
          #
          # *Deprecation notice*:
          # [_data_frame/transforms/] is deprecated, use [_transform/] in the future.
          # Deprecated since version 7.5.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/update-transform.html
          #
          def update_transform(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/#{Elasticsearch::API::Utils.__listify(_transform_id)}/_update"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:update_transform, [
            :defer_validation
          ].freeze)
      end
    end
    end
  end
end
