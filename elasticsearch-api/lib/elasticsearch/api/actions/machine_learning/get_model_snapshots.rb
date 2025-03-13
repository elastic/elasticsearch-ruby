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
        # Get model snapshots info.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [String] :snapshot_id A numerical character string that uniquely identifies the model snapshot. You can get information for multiple
        #  snapshots by using a comma-separated list or a wildcard expression. You can get all snapshots by using +_all+,
        #  by specifying +*+ as the snapshot ID, or by omitting the snapshot ID.
        # @option arguments [Boolean] :desc If true, the results are sorted in descending order.
        # @option arguments [String, Time] :end Returns snapshots with timestamps earlier than this time.
        # @option arguments [Integer] :from Skips the specified number of snapshots. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of snapshots to obtain. Server default: 100.
        # @option arguments [String] :sort Specifies the sort field for the requested snapshots. By default, the
        #  snapshots are sorted by their timestamp.
        # @option arguments [String, Time] :start Returns snapshots with timestamps after this time.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-model-snapshots
        #
        def get_model_snapshots(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_model_snapshots' }

          defined_params = [:job_id, :snapshot_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          _snapshot_id = arguments.delete(:snapshot_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _job_id && _snapshot_id
                     "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/model_snapshots/#{Utils.listify(_snapshot_id)}"
                   else
                     "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/model_snapshots"
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
