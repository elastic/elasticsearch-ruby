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
        # Retrieves anomaly detection job results for one or more influencers.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job
        # @option arguments [Boolean] :exclude_interim Exclude interim results
        # @option arguments [Integer] :from skips a number of influencers
        # @option arguments [Integer] :size specifies a max number of influencers to get
        # @option arguments [String] :start start timestamp for the requested influencers
        # @option arguments [String] :end end timestamp for the requested influencers
        # @option arguments [Double] :influencer_score influencer score threshold for the requested influencers
        # @option arguments [String] :sort sort field for the requested influencers
        # @option arguments [Boolean] :desc whether the results should be sorted in decending order
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Influencer selection criteria
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ml-get-influencer.html
        #
        def get_influencers(arguments = {})
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

          path   = "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/results/influencers"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
