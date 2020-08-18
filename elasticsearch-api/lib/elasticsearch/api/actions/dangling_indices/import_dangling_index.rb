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
    module DanglingIndices
      module Actions
        # Imports the specified dangling index
        #
        # @option arguments [String] :index_uuid The UUID of the dangling index
        # @option arguments [Boolean] :accept_data_loss Must be set to true in order to import the dangling index
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-gateway-dangling-indices.html
        #
        def import_dangling_index(arguments = {})
          raise ArgumentError, "Required argument 'index_uuid' missing" unless arguments[:index_uuid]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index_uuid = arguments.delete(:index_uuid)

          method = Elasticsearch::API::HTTP_POST
          path   = "_dangling/#{Utils.__listify(_index_uuid)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:import_dangling_index, [
          :accept_data_loss,
          :timeout,
          :master_timeout
        ].freeze)
      end
    end
  end
end
