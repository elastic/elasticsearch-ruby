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
    module Actions
      # Evaluate kNN search settings.
      # Estimate the recall and cost of approximate kNN search configurations on a `dense_vector` field against a more thorough baseline.
      # The field must use the `bbq_disk` index type, and must not be inside a nested object.
      # Each `knn_settings` entry reports the mean recall of the baseline's top `k`, not of relevance judgments, plus included and excluded query counts and cost totals.
      # A query is excluded from the mean recall when the candidate finds a document scoring above the baseline's lowest top `k` score.
      # A baseline returning fewer than `k` hits fails that query, because recall at `k` is undefined.
      # All configurations run against one point in time.
      # The default baseline uses a `visit_percentage` of 20 and a `rescore_vector.oversample` of 100.
      # An exact full-precision baseline must be requested explicitly with `allow_exact_baseline`, and is limited to 100 million vector-by-query comparisons.
      # The request is refused when the `search.knn_eval.enabled` cluster setting or the `index.knn_eval.enabled` index setting is `false`.
      # This functionality is experimental and is not ready for production usage. Experimental
      # features may change or be removed at any time. Elastic will work to fix any issues, but
      # experimental features are not subject to the support SLA of official GA features. Specific
      # Support terms apply.
      #
      # @option arguments [String, Array] :index A comma-separated list of index names to search. (*Required*)
      # @option arguments [Boolean] :ignore_unavailable If `false`, the request returns an error if it targets a missing or closed index.
      # @option arguments [Boolean] :allow_no_indices If `false`, the request returns an error if any wildcard expression, index alias, or `_all` value targets only missing or closed indices.
      #  This behavior applies even if the request targets other open indices. Server default: true.
      # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
      #  It supports comma-separated values, such as `open,hidden`. Server default: open.
      # @option arguments [Boolean] :wait_for_completion If `true`, the request waits for the evaluation to complete.
      #  A large evaluation can run for minutes, and closing the connection, for example because of a client or proxy timeout, cancels it.
      #  If `false`, the request returns a task identifier, and stores the completed response for retrieval through the task management API. Server default: true.
      # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
      #  when they occur.
      # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
      #  returned by Elasticsearch.
      # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
      #  For example `"exists_time": "1h"` for humans and
      #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
      #  readable values will be omitted. This makes sense for responses being consumed
      #  only by machines.
      # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
      #  this option for debugging only.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-knn-eval
      #
      def knn_eval(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'knn_eval' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = "#{Utils.listify(_index)}/_knn_eval"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
