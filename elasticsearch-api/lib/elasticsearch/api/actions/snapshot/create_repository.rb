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

        # Create a repository for storing snapshots
        #
        # @example Create a repository at `/tmp/backup`
        #
        #     client.snapshot.create_repository repository: 'my-backups',
        #                                       body: {
        #                                         type: 'fs',
        #                                         settings: { location: '/tmp/backup', compress: true  }
        #                                       }
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [Hash] :body The repository definition (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :verify Whether to verify the repository after creation
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-snapshots.html#_repositories
        #
        def create_repository(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'body' missing"       unless arguments[:body]
          repository = arguments.delete(:repository)

          method = HTTP_PUT
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository) )

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:create_repository, [
            :master_timeout,
            :timeout,
            :verify ].freeze)
      end
    end
  end
end
