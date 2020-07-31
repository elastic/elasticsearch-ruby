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
      module Cat
        module Actions
          # Gets configuration and usage information about anomaly detection jobs.
          #
          # @option arguments [String] :job_id The ID of the jobs stats to fetch
          # @option arguments [Boolean] :allow_no_jobs Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
          # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          # @option arguments [List] :h Comma-separated list of column names to display
          # @option arguments [Boolean] :help Return help information
          # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
          # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
          # @option arguments [Boolean] :v Verbose mode. Display column headers
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/7.x/cat-anomaly-detectors.html
          #
          def ml_jobs(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _job_id
                       "_cat/ml/anomaly_detectors/#{Elasticsearch::API::Utils.__listify(_job_id)}"
                     else
                       "_cat/ml/anomaly_detectors"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:ml_jobs, [
            :allow_no_jobs,
            :bytes,
            :format,
            :h,
            :help,
            :s,
            :time,
            :v
          ].freeze)
        end
      end
    end
  end
end
