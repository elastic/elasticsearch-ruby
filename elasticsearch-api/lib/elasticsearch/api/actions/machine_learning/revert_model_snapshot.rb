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
        # Revert to a snapshot.
        # The machine learning features react quickly to anomalous input, learning new
        # behaviors in data. Highly anomalous input increases the variance in the
        # models whilst the system learns whether this is a new step-change in behavior
        # or a one-off event. In the case where this anomalous input is known to be a
        # one-off, then it might be appropriate to reset the model state to a time
        # before this event. For example, you might consider reverting to a saved
        # snapshot after Black Friday or a critical system failure.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [String] :snapshot_id You can specify +empty+ as the <snapshot_id>. Reverting to the empty
        #  snapshot means the anomaly detection job starts learning a new model from
        #  scratch when it is started. (*Required*)
        # @option arguments [Boolean] :delete_intervening_results If true, deletes the results in the time period between the latest
        #  results and the time of the reverted snapshot. It also resets the model
        #  to accept records for this time period. If you choose not to delete
        #  intervening results when reverting a snapshot, the job will not accept
        #  input data that is older than the current time. If you want to resend
        #  data, then delete the intervening results.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-revert-model-snapshot
        #
        def revert_model_snapshot(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.revert_model_snapshot' }

          defined_params = [:job_id, :snapshot_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
          raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          _snapshot_id = arguments.delete(:snapshot_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/model_snapshots/#{Utils.listify(_snapshot_id)}/_revert"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
