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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module QueryRules
      module Actions
        # Get a query rule.
        # Get details about a query rule within a query ruleset.
        #
        # @option arguments [String] :ruleset_id The unique identifier of the query ruleset containing the rule to retrieve (*Required*)
        # @option arguments [String] :rule_id The unique identifier of the query rule within the specified ruleset to retrieve (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-query-rules-get-rule
        #
        def get_rule(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'query_rules.get_rule' }

          defined_params = [:ruleset_id, :rule_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'ruleset_id' missing" unless arguments[:ruleset_id]
          raise ArgumentError, "Required argument 'rule_id' missing" unless arguments[:rule_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _ruleset_id = arguments.delete(:ruleset_id)

          _rule_id = arguments.delete(:rule_id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_query_rules/#{Utils.listify(_ruleset_id)}/_rule/#{Utils.listify(_rule_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
