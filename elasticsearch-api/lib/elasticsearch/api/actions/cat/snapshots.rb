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
    module Cat
      module Actions

        # Shows all snapshots that belong to a specific repository
        #
        # @example Return snapshots for 'my_repository'
        #
        #     client.cat.snapshots repository: 'my_repository'
        #
        # @example Return id, status and start_epoch for 'my_repository'
        #
        #     client.cat.snapshots repository: 'my_repository', h: 'id,status,start_epoch'
        #
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-snapshots.html
        #
        def snapshots(arguments={})
          raise ArgumentError, "Required argument 'repository' missing" if !arguments[:repository] && !arguments[:help]
          repository = arguments.delete(:repository)

          method = HTTP_GET
          path   = Utils.__pathify "_cat/snapshots", Utils.__escape(repository)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:snapshots, [
            :master_timeout,
            :h,
            :help,
            :v,
            :s ].freeze)
      end
    end
  end
end

