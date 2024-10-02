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
        # Allows you to split an existing index into a new index with more primary shards.
        #
        # @option arguments [String] :index The name of the source index to split
        # @option arguments [String] :target The name of the target index to split into
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the shrunken index before the operation returns.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/indices-split-index.html
        #
        def split(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.split' }

          defined_params = %i[index target].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _index = arguments.delete(:index)

          _target = arguments.delete(:target)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.__listify(_index)}/_split/#{Utils.__listify(_target)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
