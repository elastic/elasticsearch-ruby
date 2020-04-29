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
      module IndexLifecycleManagement
        module Actions
          # Retry executing the policy for an index that is in the ERROR step
          #
          # @option arguments [String] :index The target index (*Required*)
          # @option arguments [Time] :master_timeout Specifies the period of time to wait for a connection to the master node
          # @option arguments [Time] :timeout Specifies the period of time to wait for a response.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ilm-move-to-step.html
          #
          def retry_policy(arguments = {})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            method = Elasticsearch::API::HTTP_POST
            index = Elasticsearch::API::Utils.__escape(arguments.delete(:index))
            path = Elasticsearch::API::Utils.__pathify index, "_ilm/retry"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          ParamsRegistry.register(:retry_policy, [:master_timeout,
                                                  :timeout].freeze)
        end
      end
    end
  end
end
