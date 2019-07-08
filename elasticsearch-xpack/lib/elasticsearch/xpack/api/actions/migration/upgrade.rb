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
  module XPack
    module API
      module Migration
        module Actions

          # Perform the upgrade of internal indices to make them compatible with the next major version
          #
          # @option arguments [String] :index The name of the index (*Required*)
          # @option arguments [Boolean] :wait_for_completion Should the request block until the upgrade operation is completed
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/migration-api-upgrade.html
          #
          def upgrade(arguments={})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            valid_params = [
              :wait_for_completion ]

            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify "_migration/upgrade", arguments[:index]
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
