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

          # Start a datafeed
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to start (*Required*)
          # @option arguments [Hash] :body The start datafeed parameters
          # @option arguments [String] :start The start time from where the datafeed should begin
          # @option arguments [String] :end The end time when the datafeed should stop. When not set, the datafeed continues in real time
          # @option arguments [Time] :timeout Controls the time to wait until a datafeed has started. Default to 20 seconds
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-start-datafeed.html
          #
          def start_datafeed(arguments={})
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

            valid_params = [
              :start,
              :end,
              :timeout ]

            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/datafeeds/#{arguments[:datafeed_id]}/_start"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
