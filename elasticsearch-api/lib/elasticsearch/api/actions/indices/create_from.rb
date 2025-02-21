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
# Auto generated from commit dcb1c1df18a84a0182caa631b4577d89a4602cfe
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Create an index from a source index.
        # Copy the mappings and settings from the source index to a destination index while allowing request settings and mappings to override the source values.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :source The source index or data stream name (*Required*)
        # @option arguments [String] :dest The destination index or data stream name (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body create_from
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/migrate-data-stream.html
        #
        def create_from(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.create_from' }

          defined_params = [:source, :dest].inject({}) do |set_variables, variable|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
            set_variables
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
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
