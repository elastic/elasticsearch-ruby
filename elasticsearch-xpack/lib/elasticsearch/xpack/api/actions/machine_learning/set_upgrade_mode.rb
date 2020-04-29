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
          # Sets a cluster wide upgrade_mode setting that prepares machine learning indices for an upgrade.
          #
          # @option arguments [Boolean] :enabled Whether to enable upgrade_mode ML setting or not. Defaults to false.
          # @option arguments [Time] :timeout Controls the time to wait before action times out. Defaults to 30 seconds
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-set-upgrade-mode.html
          #
          def set_upgrade_mode(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/set_upgrade_mode"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:set_upgrade_mode, [
            :enabled,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
