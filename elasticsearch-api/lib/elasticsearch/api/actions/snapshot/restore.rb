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
  module API
    module Snapshot
      module Actions
        # Restores a snapshot.
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [String] :snapshot A snapshot name
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :wait_for_completion Should this request wait until the operation has completed before returning
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Details of what to restore
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/modules-snapshots.html
        #
        def restore(arguments = {})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.__listify(_repository)}/#{Utils.__listify(_snapshot)}/_restore"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:restore, [
          :master_timeout,
          :wait_for_completion
        ].freeze)
      end
    end
  end
end
