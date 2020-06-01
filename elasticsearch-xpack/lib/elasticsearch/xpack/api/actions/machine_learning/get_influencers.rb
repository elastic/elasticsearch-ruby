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

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieves anomaly detection job results for one or more influencers.
          #
          # @option arguments [String] :job_id Identifier for the anomaly detection job
          # @option arguments [Boolean] :exclude_interim Exclude interim results
          # @option arguments [Int] :from skips a number of influencers
          # @option arguments [Int] :size specifies a max number of influencers to get
          # @option arguments [String] :start start timestamp for the requested influencers
          # @option arguments [String] :end end timestamp for the requested influencers
          # @option arguments [Double] :influencer_score influencer score threshold for the requested influencers
          # @option arguments [String] :sort sort field for the requested influencers
          # @option arguments [Boolean] :desc whether the results should be sorted in decending order
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Influencer selection criteria
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/ml-get-influencer.html
          #
          def get_influencers(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/results/influencers"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_influencers, [
            :exclude_interim,
            :from,
            :size,
            :start,
            :end,
            :influencer_score,
            :sort,
            :desc
          ].freeze)
      end
    end
    end
  end
end
