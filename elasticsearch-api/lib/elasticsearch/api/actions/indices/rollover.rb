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
#
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Updates an alias to point to a new index when the existing index
        # is considered to be too large or too old.
        #
        # @option arguments [String] :alias The name of the alias to rollover
        # @option arguments [String] :new_index The name of the rollover index
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :dry_run If set to true the rollover action will only be validated but not actually performed even if a condition matches. The default is false
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the newly created rollover index before the operation returns.
        # @option arguments [Boolean] :lazy If set to true, the rollover action will only mark a data stream to signal that it needs to be rolled over at the next write. Only allowed on data streams.
        # @option arguments [Boolean] :target_failure_store If set to true, the rollover action will be applied on the failure store of the data stream.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The conditions that needs to be met for executing rollover
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/indices-rollover-index.html
        #
        def rollover(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.rollover' }

          defined_params = %i[alias new_index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'alias' missing" unless arguments[:alias]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _alias = arguments.delete(:alias)

          _new_index = arguments.delete(:new_index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _alias && _new_index
                     "#{Utils.__listify(_alias)}/_rollover/#{Utils.__listify(_new_index)}"
                   else
                     "#{Utils.__listify(_alias)}/_rollover"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
