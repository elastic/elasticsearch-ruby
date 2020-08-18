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
    module Indices
      module Actions
        # Creates an index with optional settings and mappings.
        #
        # @option arguments [String] :index The name of the index
        # @option arguments [Boolean] :include_type_name Whether a type should be expected in the body of the mappings.
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for before the operation returns.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The configuration for the index (`settings` and `mappings`)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.9/indices-create-index.html
        #
        def create(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.__listify(_index)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:create, [
          :include_type_name,
          :wait_for_active_shards,
          :timeout,
          :master_timeout
        ].freeze)
      end
    end
  end
end
