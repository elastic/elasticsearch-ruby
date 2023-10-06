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
    module QueryRuleset
      module Actions
        # Returns the details about a query ruleset.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :ruleset_id The unique identifier of the query ruleset
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.11/get-query-ruleset.html
        #
        def get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || "query_ruleset.get" }

          defined_params = [:ruleset_id].inject({}) do |set_variables, variable|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
            set_variables
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'ruleset_id' missing" unless arguments[:ruleset_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _ruleset_id = arguments.delete(:ruleset_id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_query_rules/#{Utils.__listify(_ruleset_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
