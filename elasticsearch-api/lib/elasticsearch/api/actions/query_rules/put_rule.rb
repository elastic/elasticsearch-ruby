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
    module QueryRules
      module Actions
        # Creates or updates a query rule within a ruleset.
        #
        # @option arguments [String] :ruleset_id The unique identifier of the ruleset this rule should be added to. The ruleset will be created if it does not exist.
        # @option arguments [String] :rule_id The unique identifier of the rule to be created or updated.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The query rule configuration, including the type of rule, the criteria to match the rule, and the action that should be taken if the rule matches. (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/put-query-rule.html
        #
        def put_rule(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'query_rules.put_rule' }

          defined_params = %i[ruleset_id rule_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'ruleset_id' missing" unless arguments[:ruleset_id]
          raise ArgumentError, "Required argument 'rule_id' missing" unless arguments[:rule_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _ruleset_id = arguments.delete(:ruleset_id)

          _rule_id = arguments.delete(:rule_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_query_rules/#{Utils.__listify(_ruleset_id)}/_rule/#{Utils.__listify(_rule_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
