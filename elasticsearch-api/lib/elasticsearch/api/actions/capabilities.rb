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
    module Actions
      # Checks if the specified combination of method, API, parameters, and arbitrary capabilities are supported
      # This functionality is Experimental and may be changed or removed
      # completely in a future release. Elastic will take a best effort approach
      # to fix any issues, but experimental features are not subject to the
      # support SLA of official GA features.
      #
      # @option arguments [String] :method REST method to check (options: GET, HEAD, POST, PUT, DELETE)
      # @option arguments [String] :path API path to check
      # @option arguments [String] :parameters Comma-separated list of API parameters to check
      # @option arguments [String] :capabilities Comma-separated list of arbitrary API capabilities to check
      # @option arguments [Boolean] :local_only True if only the node being called should be considered
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://github.com/elastic/elasticsearch/blob/8.16/rest-api-spec/src/yamlRestTest/resources/rest-api-spec/test/README.asciidoc#require-or-skip-api-capabilities
      #
      def capabilities(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'capabilities' }

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body   = nil

        method = Elasticsearch::API::HTTP_GET
        path   = '_capabilities'
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
