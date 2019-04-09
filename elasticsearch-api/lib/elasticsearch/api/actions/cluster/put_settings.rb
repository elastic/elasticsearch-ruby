# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Cluster
      module Actions

        # Update cluster settings.
        #
        # @example Disable shard allocation in the cluster until restart
        #
        #     client.cluster.put_settings body: { transient: { 'cluster.routing.allocation.disable_allocation' => true } }
        #
        # @option arguments [Hash] :body The settings to be updated. Can be either `transient` or `persistent`
        #                                (survives cluster restart).
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def put_settings(arguments={})
          method = HTTP_PUT
          path   = "_cluster/settings"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body] || {}

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:put_settings, [
            :flat_settings,
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
