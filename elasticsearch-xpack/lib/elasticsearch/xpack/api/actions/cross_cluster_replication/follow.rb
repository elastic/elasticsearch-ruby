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
      module CrossClusterReplication
        module Actions
          # Creates a new follower index configured to follow the referenced leader index.
          #
          # @option arguments [String] :index The name of the follower index
          # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before returning. Defaults to 0. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The name of the leader index and other optional ccr related parameters (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.10/ccr-put-follow.html
          #
          def follow(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _index = arguments.delete(:index)

            method = Elasticsearch::API::HTTP_PUT
            path   = "#{Elasticsearch::API::Utils.__listify(_index)}/_ccr/follow"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:follow, [
            :wait_for_active_shards
          ].freeze)
        end
      end
    end
  end
end
