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
        # Retrieves overall bucket results that summarize the bucket results of multiple anomaly detection jobs.
        #
        # @option arguments [String] :job_id The job IDs for which to calculate overall bucket results
        # @option arguments [Integer] :top_n The number of top job bucket scores to be used in the overall_score calculation
        # @option arguments [String] :bucket_span The span of the overall buckets. Defaults to the longest job bucket_span
        # @option arguments [Double] :overall_score Returns overall buckets with overall scores higher than this value
        # @option arguments [Boolean] :exclude_interim If true overall buckets that include interim buckets will be excluded
        # @option arguments [String] :start Returns overall buckets with timestamps after this time
        # @option arguments [String] :end Returns overall buckets with timestamps earlier than this time
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Overall bucket selection details if not provided in URI
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ml-get-overall-buckets.html
        #
        def get_overall_buckets(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_overall_buckets' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path = "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/results/overall_buckets"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
