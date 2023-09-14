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
        # Retrieves information about model snapshots.
        #
        # @option arguments [String] :job_id The ID of the job to fetch
        # @option arguments [String] :snapshot_id The ID of the snapshot to fetch
        # @option arguments [Integer] :from Skips a number of documents
        # @option arguments [Integer] :size The default number of documents returned in queries as a string.
        # @option arguments [Date] :start The filter 'start' query parameter
        # @option arguments [Date] :end The filter 'end' query parameter
        # @option arguments [String] :sort Name of the field to sort on
        # @option arguments [Boolean] :desc True if the results should be sorted in descending order
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Model snapshot selection criteria
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-snapshot.html
        #
        def get_model_snapshots(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || "ml.get_model_snapshots" }

          defined_params = [:job_id, :snapshot_id].inject({}) do |set_variables, variable|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
            set_variables
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
                     "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/model_snapshots/#{Utils.__listify(_snapshot_id)}"
                   else
                     "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/model_snapshots"
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
