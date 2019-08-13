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
          # @option arguments [String] :job_id The ID of the jobs stats to fetch
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/ml-get-job-stats.html
          #
          def get_job_stats(arguments={})
            method = Elasticsearch::API::HTTP_GET
            path   = "_ml/anomaly_detectors/#{arguments[:job_id]}/_stats"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_job_stats, [ :allow_no_jobs ].freeze)
        end
      end
    end
  end
end
