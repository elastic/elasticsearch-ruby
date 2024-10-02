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
    module MachineLearning
      module Actions
        # Closes one or more anomaly detection jobs. A job can be opened and closed multiple times throughout its lifecycle.
        #
        # @option arguments [String] :job_id The name of the job to close
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
        # @option arguments [Boolean] :force True if the job should be forcefully closed
        # @option arguments [Time] :timeout Controls the time to wait until a job has closed. Default to 30 minutes
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The URL params optionally sent in the body
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ml-close-job.html
        #
        def close_job(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.close_job' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/_close"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
