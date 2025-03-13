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
        # Upgrade a snapshot.
        # Upgrade an anomaly detection model snapshot to the latest major version.
        # Over time, older snapshot formats are deprecated and removed. Anomaly
        # detection jobs support only snapshots that are from the current or previous
        # major version.
        # This API provides a means to upgrade a snapshot to the current major version.
        # This aids in preparing the cluster for an upgrade to the next major version.
        # Only one snapshot per anomaly detection job can be upgraded at a time and the
        # upgraded snapshot cannot be the current snapshot of the anomaly detection
        # job.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [String] :snapshot_id A numerical character string that uniquely identifies the model snapshot. (*Required*)
        # @option arguments [Boolean] :wait_for_completion When true, the API won’t respond until the upgrade is complete.
        #  Otherwise, it responds as soon as the upgrade task is assigned to a node.
        # @option arguments [Time] :timeout Controls the time to wait for the request to complete. Server default: 30m.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-upgrade-job-snapshot
        #
        def upgrade_job_snapshot(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.upgrade_job_snapshot' }

          defined_params = [:job_id, :snapshot_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
          raise ArgumentError, "Required argument 'snapshot_id' missing" unless arguments[:snapshot_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _job_id = arguments.delete(:job_id)

          _snapshot_id = arguments.delete(:snapshot_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/model_snapshots/#{Utils.listify(_snapshot_id)}/_upgrade"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
