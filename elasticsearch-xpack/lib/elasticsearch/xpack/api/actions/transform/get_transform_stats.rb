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
          # @option arguments [String] :transform_id The id of the transform for which to get stats. '_all' or '*' implies all transforms
          # @option arguments [Number] :from skips a number of transform stats, defaults to 0
          # @option arguments [Number] :size specifies a max number of transform stats to get, defaults to 100
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/get-transform-stats.html
          #
          def get_transform_stats(arguments = {})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_transform/#{Elasticsearch::API::Utils.__listify(_transform_id)}/_stats"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_transform_stats, [
            :from,
            :size,
            :allow_no_match
          ].freeze)
      end
    end
    end
  end
end
