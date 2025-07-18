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
        # Delete an anomaly detection job.
        # All job configuration, model state and results are deleted.
        # It is not currently possible to delete multiple jobs using wildcards or a
        # comma separated list. If you delete a job that has a datafeed, the request
        # first tries to delete the datafeed. This behavior is equivalent to calling
        # the delete datafeed API with the same timeout and force parameters as the
        # delete job request.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [Boolean] :force Use to forcefully delete an opened job; this method is quicker than
        #  closing and deleting the job.
        # @option arguments [Boolean] :delete_user_annotations Specifies whether annotations that have been added by the
        #  user should be deleted along with any auto-generated annotations when the job is
        #  reset.
        # @option arguments [Boolean] :wait_for_completion Specifies whether the request should return immediately or wait until the
        #  job deletion completes. Server default: true.
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
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-delete-job
        #
        def delete_job(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_job' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
