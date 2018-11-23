# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Retrieve job results for one or more influencers
          #
          # @option arguments [String] :job_id [TODO] (*Required*)
          # @option arguments [Hash] :body Influencer selection criteria
          # @option arguments [Boolean] :exclude_interim Exclude interim results
          # @option arguments [Int] :from skips a number of influencers
          # @option arguments [Int] :size specifies a max number of influencers to get
          # @option arguments [String] :start start timestamp for the requested influencers
          # @option arguments [String] :end end timestamp for the requested influencers
          # @option arguments [Double] :influencer_score influencer score threshold for the requested influencers
          # @option arguments [String] :sort sort field for the requested influencers
          # @option arguments [Boolean] :desc whether the results should be sorted in decending order
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-influencer.html
          #
          def get_influencers(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            valid_params = [
              :exclude_interim,
              :from,
              :size,
              :start,
              :end,
              :influencer_score,
              :sort,
              :desc ]
            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/anomaly_detectors/#{arguments[:job_id]}/results/influencers"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
