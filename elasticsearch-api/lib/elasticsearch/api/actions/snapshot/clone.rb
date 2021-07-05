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
        # Clones indices from one snapshot into another snapshot in the same repository.
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [String] :snapshot The name of the snapshot to clone from
        # @option arguments [String] :target_snapshot The name of the cloned snapshot to create
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The snapshot clone definition (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.14/modules-snapshots.html
        #
        def clone(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]
          raise ArgumentError, "Required argument 'target_snapshot' missing" unless arguments[:target_snapshot]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          _target_snapshot = arguments.delete(:target_snapshot)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_snapshot/#{Utils.__listify(_repository)}/#{Utils.__listify(_snapshot)}/_clone/#{Utils.__listify(_target_snapshot)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:clone, [
          :master_timeout
        ].freeze)
      end
    end
  end
end
