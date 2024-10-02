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
        # Retrieves anomaly detection job results for one or more buckets.
        #
        # @option arguments [String] :job_id ID of the job to get bucket results from
        # @option arguments [String] :timestamp The timestamp of the desired single bucket result
        # @option arguments [Boolean] :expand Include anomaly records
        # @option arguments [Boolean] :exclude_interim Exclude interim results
        # @option arguments [Integer] :from skips a number of buckets
        # @option arguments [Integer] :size specifies a max number of buckets to get
        # @option arguments [String] :start Start time filter for buckets
        # @option arguments [String] :end End time filter for buckets
        # @option arguments [Double] :anomaly_score Filter for the most anomalous buckets
        # @option arguments [String] :sort Sort buckets by a particular field
        # @option arguments [Boolean] :desc Set the sort direction
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Bucket selection details if not provided in URI
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ml-get-bucket.html
        #
        def get_buckets(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_buckets' }

          defined_params = %i[job_id timestamp].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          _timestamp = arguments.delete(:timestamp)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path = if _job_id && _timestamp
                   "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/results/buckets/#{Utils.__listify(_timestamp)}"
                 else
                   "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/results/buckets"
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
