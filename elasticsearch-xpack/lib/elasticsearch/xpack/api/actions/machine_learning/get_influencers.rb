# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :job_id [TODO]
          # @option arguments [Boolean] :exclude_interim Exclude interim results
          # @option arguments [Int] :from skips a number of influencers
          # @option arguments [Int] :size specifies a max number of influencers to get
          # @option arguments [String] :start start timestamp for the requested influencers
          # @option arguments [String] :end end timestamp for the requested influencers
          # @option arguments [Double] :influencer_score influencer score threshold for the requested influencers
          # @option arguments [String] :sort sort field for the requested influencers
          # @option arguments [Boolean] :desc whether the results should be sorted in decending order

          # @option arguments [Hash] :body Influencer selection criteria
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-influencer.html
          #
          def get_influencers(arguments = {})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}/results/influencers"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body).body
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
