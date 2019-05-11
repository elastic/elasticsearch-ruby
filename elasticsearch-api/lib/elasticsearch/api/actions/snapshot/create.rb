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
    module Snapshot
      module Actions

        # Create a new snapshot in the repository
        #
        # @example Create a snapshot of the whole cluster in the `my-backups` repository
        #
        #     client.snapshot.create repository: 'my-backups', snapshot: 'snapshot-1'
        #
        # @example Create a snapshot for specific indices in the `my-backups` repository
        #
        #     client.snapshot.create repository: 'my-backups',
        #                            snapshot: 'snapshot-2',
        #                            body: { indices: 'foo,bar', ignore_unavailable: true }
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [String] :snapshot A snapshot name (*Required*)
        # @option arguments [Hash] :body The snapshot definition
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :wait_for_completion Whether the request should block and wait until
        #                                                  the operation has completed
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-snapshots.html#_snapshot
        #
        def create(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing"   unless arguments[:snapshot]
          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_PUT
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__escape(snapshot) )

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:create, [
            :master_timeout,
            :wait_for_completion ].freeze)
      end
    end
  end
end
