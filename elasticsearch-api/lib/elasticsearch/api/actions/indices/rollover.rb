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
    module Indices
      module Actions

        # The rollover index API rolls an alias over to a new index when the existing index
        # is considered to be too large or too old
        #
        # @option arguments [String] :alias The name of the alias to rollover (*Required*)
        # @option arguments [String] :new_index The name of the rollover index
        # @option arguments [Hash] :body The conditions that needs to be met for executing rollover
        # @option arguments [Boolean] :include_type_name Whether a type should be included in the body of the mappings.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :dry_run If set to true the rollover action will only be validated but not actually performed even if a condition matches. The default is false
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the newly created rollover index before the operation returns.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-rollover-index.html
        #
        def rollover(arguments={})
          raise ArgumentError, "Required argument 'alias' missing" unless arguments[:alias]
          arguments = arguments.clone
          source = arguments.delete(:alias)
          target = arguments.delete(:new_index)
          method = HTTP_POST
          path   = Utils.__pathify Utils.__escape(source), '_rollover', Utils.__escape(target)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:rollover, [
            :include_type_name,
            :timeout,
            :dry_run,
            :master_timeout,
            :wait_for_active_shards ].freeze)
      end
    end
  end
end
