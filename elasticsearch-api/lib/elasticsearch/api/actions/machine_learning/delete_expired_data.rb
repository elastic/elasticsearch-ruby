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
    module MachineLearning
      module Actions
        # Delete expired ML data.
        # Delete all job results, model snapshots and forecast data that have exceeded
        # their retention days period. Machine learning state documents that are not
        # associated with any job are also deleted.
        # You can limit the request to a single or set of anomaly detection jobs by
        # using a job identifier, a group name, a comma-separated list of jobs, or a
        # wildcard expression. You can delete expired data for all anomaly detection
        # jobs by using `_all`, by specifying `*` as the `<job_id>`, or by omitting the
        # `<job_id>`.
        #
        # @option arguments [String] :job_id Identifier for an anomaly detection job. It can be a job identifier, a
        #  group name, or a wildcard expression.
        # @option arguments [Float] :requests_per_second The desired requests per second for the deletion processes. The default
        #  behavior is no throttling.
        # @option arguments [Time] :timeout How long can the underlying delete processes run until they are canceled. Server default: 8h.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-delete-expired-data
        #
        def delete_expired_data(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_expired_data' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = if _job_id
                     "_ml/_delete_expired_data/#{Utils.listify(_job_id)}"
                   else
                     '_ml/_delete_expired_data'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
