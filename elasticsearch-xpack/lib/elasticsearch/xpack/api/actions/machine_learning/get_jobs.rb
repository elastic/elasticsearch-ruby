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
          # Retrieves configuration information for anomaly detection jobs.
          #
          # @option arguments [String] :job_id The ID of the jobs to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified) *Deprecated*
          # @option arguments [Boolean] :for_export Omits fields that are illegal to set on job PUT
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-job.html
          #
          def get_jobs(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _job_id
                       "_ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}"
                     else
                       "_ml/anomaly_detectors"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_jobs, [
            :allow_no_match,
            :allow_no_jobs,
            :for_export
          ].freeze)
        end
      end
    end
  end
end
