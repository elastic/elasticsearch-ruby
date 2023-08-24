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
        # Stops one or more data frame analytics jobs.
        #
        # @option arguments [String] :id The ID of the data frame analytics to stop
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no data frame analytics. (This includes `_all` string or when no data frame analytics have been specified)
        # @option arguments [Boolean] :force True if the data frame analytics should be forcefully stopped
        # @option arguments [Time] :timeout Controls the time to wait until the task has stopped. Defaults to 20 seconds
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The stop data frame analytics parameters
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/stop-dfanalytics.html
        #
        def stop_data_frame_analytics(arguments = {})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/data_frame/analytics/#{Utils.__listify(_id)}/_stop"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
