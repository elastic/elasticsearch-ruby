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
# Auto generated from build hash 589cd632d091bc0a512c46d5d81ac1f961b60127
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Create an index from a source index
        #
        # @option arguments [String] :source The source index name
        # @option arguments [String] :dest The destination index name
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The body contains the fields `mappings_override`, `settings_override`, and `remove_index_blocks`.
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/migrate-data-stream.html
        #
        def create_from(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.create_from' }

          defined_params = %i[source dest].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'source' missing" unless arguments[:source]
          raise ArgumentError, "Required argument 'dest' missing" unless arguments[:dest]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _source = arguments.delete(:source)

          _dest = arguments.delete(:dest)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_create_from/#{Utils.__listify(_source)}/#{Utils.__listify(_dest)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
