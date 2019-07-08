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
      module Security
        module Actions

          # Clears the internal user caches for specified realms
          #
          # @option arguments [String] :realms Comma-separated list of realms to clear (*Required*)
          # @option arguments [String] :usernames Comma-separated list of usernames to clear from the cache
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/security-api-clear-cache.html
          #
          def clear_cached_realms(arguments={})
            raise ArgumentError, "Required argument 'realms' missing" unless arguments[:realms]

            valid_params = [ :usernames ]

            arguments = arguments.clone
            realms = arguments.delete(:realms)

            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify "_security/realm/", Elasticsearch::API::Utils.__listify(realms), "_clear_cache"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
