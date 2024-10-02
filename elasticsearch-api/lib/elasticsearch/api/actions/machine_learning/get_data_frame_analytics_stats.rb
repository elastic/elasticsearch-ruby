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
        # Retrieves usage information for data frame analytics jobs.
        #
        # @option arguments [String] :id The ID of the data frame analytics stats to fetch
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no data frame analytics. (This includes `_all` string or when no data frame analytics have been specified)
        # @option arguments [Integer] :from skips a number of analytics
        # @option arguments [Integer] :size specifies a max number of analytics to get
        # @option arguments [Boolean] :verbose whether the stats response should be verbose
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/get-dfanalytics-stats.html
        #
        def get_data_frame_analytics_stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_data_frame_analytics_stats' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _id
                     "_ml/data_frame/analytics/#{Utils.__listify(_id)}/_stats"
                   else
                     '_ml/data_frame/analytics/_stats'
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
