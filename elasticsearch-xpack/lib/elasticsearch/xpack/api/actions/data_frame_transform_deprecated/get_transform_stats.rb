# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module XPack
    module API
      module DataFrameTransformDeprecated
        module Actions
          # Retrieves usage information for transforms.
          # This functionality is in Beta and is subject to change. The design and
          # code is less mature than official GA features and is being provided
          # as-is with no warranties. Beta features are not subject to the support
          # SLA of official GA features.
          #
          # @option arguments [String] :transform_id The id of the transform for which to get stats. '_all' or '*' implies all transforms
          # @option arguments [Number] :from skips a number of transform stats, defaults to 0
          # @option arguments [Number] :size specifies a max number of transform stats to get, defaults to 100
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # *Deprecation notice*:
          # [_data_frame/transforms/] is deprecated, use [_transform/] in the future.
          # Deprecated since version 7.5.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/get-transform-stats.html
          #
          def get_transform_stats(arguments = {})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_data_frame/transforms/#{Elasticsearch::API::Utils.__listify(_transform_id)}/_stats"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
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
