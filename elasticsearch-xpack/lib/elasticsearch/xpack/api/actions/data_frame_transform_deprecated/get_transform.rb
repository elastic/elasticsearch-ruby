# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrameTransformDeprecated
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :transform_id The id or comma delimited list of id expressions of the transforms to get, '_all' or '*' implies get all transforms
          # @option arguments [Int] :from skips a number of transform configs, defaults to 0
          # @option arguments [Int] :size specifies a max number of transforms to get, defaults to 100
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)

          #
          # *Deprecation notice*:
          # [_data_frame/transforms/] is deprecated, use [_transform/] in the future.
          # Deprecated since version 7.5.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/get-transform.html
          #
          def get_transform(arguments = {})
            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _transform_id
                       "_data_frame/transforms/#{Elasticsearch::API::Utils.__listify(_transform_id)}"
                     else
                       "_data_frame/transforms"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_transform, [
            :from,
            :size,
            :allow_no_match
          ].freeze)
      end
    end
    end
  end
end
