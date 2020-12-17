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
          # Retrieves usage information for data frame analytics jobs.
          # This functionality is in Beta and is subject to change. The design and
          # code is less mature than official GA features and is being provided
          # as-is with no warranties. Beta features are not subject to the support
          # SLA of official GA features.
          #
          # @option arguments [String] :id The ID of the data frame analytics stats to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no data frame analytics. (This includes `_all` string or when no data frame analytics have been specified)
          # @option arguments [Int] :from skips a number of analytics
          # @option arguments [Int] :size specifies a max number of analytics to get
          # @option arguments [Boolean] :verbose whether the stats response should be verbose
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.11/get-dfanalytics-stats.html
          #
          def get_data_frame_analytics_stats(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _id
                       "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}/_stats"
                     else
                       "_ml/data_frame/analytics/_stats"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_data_frame_analytics_stats, [
            :allow_no_match,
            :from,
            :size,
            :verbose
          ].freeze)
        end
      end
    end
  end
end
