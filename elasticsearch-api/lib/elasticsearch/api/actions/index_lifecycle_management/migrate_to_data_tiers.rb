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
#
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module IndexLifecycleManagement
      module Actions
        # Migrate to data tiers routing.
        # Switch the indices, ILM policies, and legacy, composable, and component templates from using custom node attributes and attribute-based allocation filters to using data tiers.
        # Optionally, delete one legacy index template.
        # Using node roles enables ILM to automatically move the indices between data tiers.
        # Migrating away from custom node attributes routing can be manually performed.
        # This API provides an automated way of performing three out of the four manual steps listed in the migration guide:
        # 1. Stop setting the custom hot attribute on new indices.
        # 1. Remove custom allocation settings from existing ILM policies.
        # 1. Replace custom allocation settings from existing indices with the corresponding tier preference.
        # ILM must be stopped before performing the migration.
        # Use the stop ILM and get ILM status APIs to wait until the reported operation mode is +STOPPED+.
        #
        # @option arguments [Boolean] :dry_run If true, simulates the migration from node attributes based allocation filters to data tiers, but does not perform the migration.
        #  This provides a way to retrieve the indices and ILM policies that need to be migrated.
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error.
        #  It can also be set to +-1+ to indicate that the request should never timeout. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ilm-migrate-to-data-tiers
        #
        def migrate_to_data_tiers(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ilm.migrate_to_data_tiers' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_ilm/migrate_to_data_tiers'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
