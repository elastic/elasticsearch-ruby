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
        # Create or update a query ruleset.
        # There is a limit of 100 rules per ruleset.
        # This limit can be increased by using the `xpack.applications.rules.max_rules_per_ruleset` cluster setting.
        # IMPORTANT: Due to limitations within pinned queries, you can only select documents using `ids` or `docs`, but cannot use both in single rule.
        # It is advised to use one or the other in query rulesets, to avoid errors.
        # Additionally, pinned queries have a maximum limit of 100 pinned hits.
        # If multiple matching rules pin more than 100 documents, only the first 100 documents are pinned in the order they are specified in the ruleset.
        #
        # @option arguments [String] :ruleset_id The unique identifier of the query ruleset to be created or updated. (*Required*)
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-query-rules-put-ruleset
        #
        def put_ruleset(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'query_rules.put_ruleset' }

          defined_params = [:ruleset_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'ruleset_id' missing" unless arguments[:ruleset_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _ruleset_id = arguments.delete(:ruleset_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_query_rules/#{Utils.listify(_ruleset_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
