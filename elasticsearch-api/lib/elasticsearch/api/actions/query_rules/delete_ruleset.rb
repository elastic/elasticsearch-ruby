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
# Auto generated from commit 69cbe7cbe9f49a2886bb419ec847cffb58f8b4fb
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module QueryRules
      module Actions
        # Delete a query ruleset.
        # Remove a query ruleset and its associated data.
        # This is a destructive action that is not recoverable.
        #
        # @option arguments [String] :ruleset_id The unique identifier of the query ruleset to delete (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-query-rules-delete-ruleset
        #
        def delete_ruleset(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'query_rules.delete_ruleset' }

          defined_params = [:ruleset_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'ruleset_id' missing" unless arguments[:ruleset_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _ruleset_id = arguments.delete(:ruleset_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_query_rules/#{Utils.listify(_ruleset_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
