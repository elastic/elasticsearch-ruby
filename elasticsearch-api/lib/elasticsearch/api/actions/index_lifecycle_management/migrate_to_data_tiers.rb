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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module IndexLifecycleManagement
      module Actions
        # Migrates the indices and ILM policies away from custom node attribute allocation routing to data tiers routing
        #
        # @option arguments [Boolean] :dry_run If set to true it will simulate the migration, providing a way to retrieve the ILM policies and indices that need to be migrated. The default is false
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Optionally specify a legacy index template name to delete and optionally specify a node attribute name used for index shard routing (defaults to "data")
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ilm-migrate-to-data-tiers.html
        #
        def migrate_to_data_tiers(arguments = {})
          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ilm/migrate_to_data_tiers"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
