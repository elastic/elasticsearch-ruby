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
      module MachineLearning
        module Actions
          # Updates certain properties of a datafeed.
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to update
          # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
          # @option arguments [Boolean] :allow_no_indices Ignore if the source indices expressions resolves to no concrete indices (default: true)
          # @option arguments [Boolean] :ignore_throttled Ignore indices that are marked as throttled (default: true)
          # @option arguments [String] :expand_wildcards Whether source index expressions should get expanded to open or closed indices (default: open) (options: open, closed, hidden, none, all)
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The datafeed update settings (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.11/ml-update-datafeed.html
          #
          def update_datafeed(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _datafeed_id = arguments.delete(:datafeed_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/datafeeds/#{Elasticsearch::API::Utils.__listify(_datafeed_id)}/_update"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:update_datafeed, [
            :ignore_unavailable,
            :allow_no_indices,
            :ignore_throttled,
            :expand_wildcards
          ].freeze)
        end
      end
    end
  end
end
