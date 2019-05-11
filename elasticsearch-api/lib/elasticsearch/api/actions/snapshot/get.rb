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

        # Return information about specific (or all) snapshots
        #
        # @example Return information about the `snapshot-2` snapshot
        #
        #     client.snapshot.get repository: 'my-backup', snapshot: 'snapshot-2'
        #
        # @example Return information about multiple snapshots
        #
        #     client.snapshot.get repository: 'my-backup', snapshot: ['snapshot-2', 'snapshot-3']
        #
        # @example Return information about all snapshots in the repository
        #
        #     client.snapshot.get repository: 'my-backup', snapshot: '_all'
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [List] :snapshot A comma-separated list of snapshot names (*Required*)
        # @option arguments [Boolean] :ignore_unavailable Whether to ignore unavailable snapshots, defaults to
        #   false which means a SnapshotMissingException is thrown
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :verbose Whether to show verbose snapshot info or only show the basic info found in the repository index blob
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def get(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing"   unless arguments[:snapshot]
          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)

          method = HTTP_GET
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository), Utils.__listify(snapshot) )

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:get, [
            :ignore_unavailable,
            :master_timeout,
            :verbose ].freeze)
      end
    end
  end
end
