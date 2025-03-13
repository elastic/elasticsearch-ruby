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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Close anomaly detection jobs.
        # A job can be opened and closed multiple times throughout its lifecycle. A closed job cannot receive data or perform analysis operations, but you can still explore and navigate results.
        # When you close a job, it runs housekeeping tasks such as pruning the model history, flushing buffers, calculating final results and persisting the model snapshots. Depending upon the size of the job, it could take several minutes to close and the equivalent time to re-open. After it is closed, the job has a minimal overhead on the cluster except for maintaining its meta data. Therefore it is a best practice to close jobs that are no longer required to process data.
        # If you close an anomaly detection job whose datafeed is running, the request first tries to stop the datafeed. This behavior is equivalent to calling stop datafeed API with the same timeout and force parameters as the close job request.
        # When a datafeed that has a specified end date stops, it automatically closes its associated job.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. It can be a job identifier, a group name, or a wildcard expression. You can close multiple anomaly detection jobs in a single API request by using a group name, a comma-separated list of jobs, or a wildcard expression. You can close all jobs by using +_all+ or by specifying +*+ as the job identifier. (*Required*)
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request: contains wildcard expressions and there are no jobs that match; contains the  +_all+ string or no identifiers and there are no matches; or contains wildcard expressions and there are only partial matches. By default, it returns an empty jobs array when there are no matches and the subset of results when there are partial matches.
        #  If +false+, the request returns a 404 status code when there are no matches or only partial matches. Server default: true.
        # @option arguments [Boolean] :force Use to close a failed job, or to forcefully close a job which has not responded to its initial close request; the request returns without performing the associated actions such as flushing buffers and persisting the model snapshots.
        #  If you want the job to be in a consistent state after the close job API returns, do not set to +true+. This parameter should be used only in situations where the job has already failed or where you are not interested in results the job might have recently produced or might produce in the future.
        # @option arguments [Time] :timeout Controls the time to wait until a job has closed. Server default: 30m.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-close-job
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
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/_close"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
