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
        # Allow to shrink an existing index into a new index with fewer primary shards.
        #
        # @option arguments [String] :index The name of the source index to shrink
        # @option arguments [String] :target The name of the target index to shrink into
        # @option arguments [Boolean] :copy_settings whether or not to copy settings from the source index (defaults to false)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the shrunken index before the operation returns.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.14/indices-shrink-index.html
        #
        def shrink(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index = arguments.delete(:index)

          _target = arguments.delete(:target)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.__listify(_index)}/_shrink/#{Utils.__listify(_target)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:shrink, [
          :copy_settings,
          :timeout,
          :master_timeout,
          :wait_for_active_shards
        ].freeze)
      end
    end
  end
end
